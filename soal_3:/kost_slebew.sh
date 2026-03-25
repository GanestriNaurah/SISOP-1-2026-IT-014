#!/bin/bash

DATA="data/penghuni.csv"
HISTORY="sampah/history_hapus.csv"
LAPORAN="rekap/laporan_bulanan.txt"
LOG="log/tagihan.log"

mkdir -p data sampah rekap log
touch $DATA $HISTORY $LAPORAN $LOG

# =========================
# MODE CRON (CHECK TAGIHAN)
# =========================
if [ "$1" == "--check-tagihan" ]; then
    while IFS=, read -r nama kamar harga tanggal status
    do
        if [ "$status" == "Menunggak" ]; then
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] TAGIHAN: $nama (Kamar $kamar) - Menunggak Rp$harga" >> log/tagihan.log
        fi
    done < data/penghuni.csv
    exit
fi

# =========================
# MENU UTAMA
# =========================
while true
do
    clear
    echo "==== KOST SLEBEW ===="
    echo "1. Tambah Penghuni"
    echo "2. Hapus Penghuni"
    echo "3. Tampilkan Data"
    echo "4. Update Status"
    echo "5. Laporan"
    echo "6. Kelola Cron"
    echo "7. Exit"
    read -p "Pilih: " pilih

    case $pilih in

# =========================
# 1. TAMBAH
# =========================
1)
read -p "Nama: " nama
read -p "Kamar: " kamar
read -p "Harga: " harga
read -p "Tanggal (YYYY-MM-DD): " tanggal
read -p "Status (Aktif/Menunggak): " status

# validasi kamar unik
if grep -q ",$kamar," $DATA; then
    echo "Kamar sudah terisi!"
else
    echo "$nama,$kamar,$harga,$tanggal,$status" >> $DATA
    echo "[✓] Berhasil ditambahkan!"
fi

read -p "Enter..."
;;

# =========================
# 2. HAPUS
# =========================
2)
read -p "Nama yang dihapus: " nama

grep -i "$nama" $DATA >> $HISTORY
sed -i "/$nama/d" $DATA

echo "[✓] Data dipindahkan ke sampah"
read -p "Enter..."
;;

# =========================
# 3. TAMPILKAN (PAKAI AWK)
# =========================
3)
echo "=============================================="
echo "DAFTAR PENGHUNI KOST SLEBEW"
echo "=============================================="

awk -F',' '{
printf "%-3s | %-10s | %-5s | Rp%-10s | %-10s\n", NR, $1, $2, $3, $5
}' $DATA

total=$(wc -l < $DATA)
aktif=$(grep -c "Aktif" $DATA)
nunggak=$(grep -c "Menunggak" $DATA)

echo "----------------------------------------------"
echo "Total: $total | Aktif: $aktif | Menunggak: $nunggak"

read -p "Enter..."
;;

# =========================
# 4. UPDATE STATUS
# =========================
4)
read -p "Nama: " nama
read -p "Status baru (Aktif/Menunggak): " status

sed -i "s/^$nama,\([^,]*\),\([^,]*\),\([^,]*\),.*/$nama,\1,\2,\3,$status/" $DATA

echo "[✓] Status berhasil diupdate"
read -p "Enter..."
;;

# =========================
# 5. LAPORAN (FIX SESUAI SOAL)
# =========================
5)
total_aktif=$(awk -F, '$5=="Aktif" {sum+=$3} END {print sum}' $DATA)
total_tunggak=$(awk -F, '$5=="Menunggak" {sum+=$3} END {print sum}' $DATA)
jumlah=$(wc -l < $DATA)

echo "==========================================="
echo " LAPORAN KEUANGAN KOST SLEBEW"
echo "==========================================="
echo "Total pemasukan (Aktif) : Rp$total_aktif"
echo "Total tunggakan         : Rp$total_tunggak"
echo "Jumlah kamar terisi     : $jumlah"
echo "-------------------------------------------"
echo "Daftar penghuni menunggak:"

awk -F, '$5=="Menunggak" {print "- "$1" (Kamar "$2")"}' $DATA

if ! grep -q "Menunggak" $DATA; then
    echo "Tidak ada tunggakan."
fi

# simpan ke file
echo "LAPORAN KOST" > $LAPORAN
echo "Aktif: Rp$total_aktif" >> $LAPORAN
echo "Tunggakan: Rp$total_tunggak" >> $LAPORAN
echo "Jumlah: $jumlah" >> $LAPORAN

echo "[✓] Laporan disimpan ke $LAPORAN"
read -p "Enter..."
;;

# =========================
# 6. CRON (FIX TOTAL)
# =========================
6)
echo "==== MENU CRON ===="
echo "1. Lihat Cron"
echo "2. Tambah Cron"
echo "3. Hapus Cron"
echo "4. Kembali"
read -p "Pilih: " c

case $c in
1)
echo "--- Cron Aktif ---"
crontab -l 2>/dev/null || echo "Belum ada cron"
;;
2)
read -p "Jam (0-23): " jam
read -p "Menit (0-59): " menit

path=$(realpath $0)

(crontab -l 2>/dev/null; echo "$jam $menit * * * $path --check-tagihan") | crontab -

echo "[✓] Cron berhasil ditambahkan"
;;
3)
crontab -r
echo "[✓] Cron berhasil dihapus"
;;
esac

read -p "Enter..."
;;

# =========================
# 7. EXIT
# =========================
7)
exit
;;

*)
echo "Pilihan salah"
read -p "Enter..."
;;

esac
done
