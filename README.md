# Laporan Praktikum Modul 1

## Struktur Repository
```bash
├── soal_1:
│   ├── KANJ.sh
│   └── passenger.csv
├── soal_2:
│   └── ekspedisi
│       ├── peta-ekspedisi-amba.pdf
│       └── peta-gunung-kawi
│           ├── gsxtrack.json
│           ├── nemupusaka.sh
│           ├── parserkoordinat.sh
│           ├── posisipusaka.txt
│           └── titik-penting.txt
└── soal_3:
    ├── data
    │   └── penghuni.csv
    ├── kost_slebew.sh
    ├── log
    │   └── tagihan.log
    ├── rekap
    │   └── laporan_bulanan.txt
    └── sampah
        └── history_hapus.csv
```
Pada bagian ini dilakukan pembuatan folder sebanyak 3 kali. 
Terdiri dari beberapa subfolder dan file dibuat secara berurutan (folder -> subfolder -> file) dengan mkdir, cd dan touch.

## Soal 1
### Solve Code
Pada soal ini dilakukan analisis data dari file passenger.csv melalui KANJ.sh.
Pertama, dilakukan perhitungan total penumpang kereta.
```bash
if [ "$pilihan" = "a" ]; then
        awk -F, 'NR>1 {jumlah++} END {print "Total penumpang ada", jumlah}' $data
```
Kedua, dilakukan perhitungan jumlah gerbong berdasarkan data jumlah penumpang dan gerbong yang dinaiki oleh penumpang.
```bash
elif [ "$pilihan" = "b" ]; then
        awk -F, 'NR>1 {print $3}' $data | sort | uniq | wc -l
```
Ketiga, dilakukan pencarian penumpang yang paling tua dalam kereta tersebut.
```bash
elif [ "$pilihan" = "c" ]; then
        awk -F, 'NR==2 {max=$2; nama=$1} NR>1 {
                                                if ($2 > max) {
                                                        max=$2
                                                        nama=$1
                                                }
                                        }
                                        END {
                                                print "Penumpang tertua:", nama, "-", max, "tahun"
                                        }' $data
```
Keempat, dilakukan perhitungan rata-rata umur penumpang.
```bash
elif [ "$pilihan" = "d" ]; then
        awk -F, 'NR>1 {sum+=$2; n++} END {print "Rata-rata umur sekitar", int(sum/n)}' $data
```
Kelima, dilakukan perhitungan jumlah business class.
```bash
elif [ "$pilihan" = "e" ]; then
        awk -F, 'NR>1 && $3=="Business" {n++} END {print "Business class ada", n}' $data
```
Terakhir, jika suatu input tidak sesuai dengan pilihan yang tertera akan mengeluarkan peringatan "Input salah".

### Output
Berdasarkan code tersebut, maka hasil analisis data dari passenger.csv tertera sebagai berikut.
```bash
naunavy06@LAPTOP-GANESTRI:~/repository/soal_1:$ ./KANJ.sh passenger.csv a
Total penumpang ada 208
naunavy06@LAPTOP-GANESTRI:~/repository/soal_1:$ ./KANJ.sh passenger.csv b
3
naunavy06@LAPTOP-GANESTRI:~/repository/soal_1:$ ./KANJ.sh passenger.csv c
Penumpang tertua: Jaja Mihardja - 85 tahun
naunavy06@LAPTOP-GANESTRI:~/repository/soal_1:$ ./KANJ.sh passenger.csv d
Rata-rata umur sekitar 37
naunavy06@LAPTOP-GANESTRI:~/repository/soal_1:$ ./KANJ.sh passenger.csv e
Business class ada 74
naunavy06@LAPTOP-GANESTRI:~/repository/soal_1:$ ./KANJ.sh passenger.csv f
input salah
```

### Problem
Pada saat pengerjaan soal, terjadi beberapa error.
1. Typo
   Pada code perhitungan gerbong, terjadi kesalahan penulisan yang dimana wc -1 seharusnya tertulis wc -l sehingga hasil code menjadi invalid.
2. Syntax Error
   Pada kondisi if, terjadi unexpected syntax error yang dimana kondisi if tidak memiliki jarak padahal kondisi tersebut harus menggunakan spasi.
   Contoh:
	```bash 
	elif [ "$pilihan" = "b" ]; then
        awk -F, 'NR>1 {print $3}' $data | sort | uniq | wc -l 
        ```
   menjadi
	```bash
	elif["$pilihan" = "b"]; then
        awk -F, 'NR>1 {print $3}' $data | sort | uniq | wc -1
	```

## Soal 2
### Solve Code
Pada soal ini dilakukan pencarian titik koordinat dari sebuah file peta.Pada file pdf, terdapat sebuah gambar untuk kita amati apakah ada link tersembunyi atau tidak. Cara ini menggunakan gdown untuk membantu dalam mengambil link tersembunyi.
Setelah itu kita lakukan clone pada link tersebut.
```bash
git clone https://github.com/pocongcyber77/peta-gunung-kawi.git
```
Selanjutnya, ditemukan file gsxtrack.json berisi data koordinat seperti latitude, longitude, dan titik posisi. Script tersebut digunakan untuk parsing pada file parserkoordinat.sh
```bash
grep '"coordinates"' gsxtrack.json | \
sed 's/[][]//g; s/"coordinates"://g' | \
awk -F',' '{
    gsub(/ /,"",$0)
    printf "node_%03d,Point%d,%s,%s\n", NR, NR, $2, $1
}' > titik-penting.txt
```
Selanjutnya, untuk menentukan posisi pusakan, dilakukan perhitungan titik tengah dari seluruh koordinat dengan menggunakan rata-rata latitude dan longitude.
```bash
#!/bin/bash

awk -F',' '
NR==1 {x1=$3; y1=$4}
NR==3 {x2=$3; y2=$4}
END {
    print "Koordinat pusat:"
    print (x1+x2)/2, (y1+y2)/2
}' titik-penting.txt > posisipusaka.txt
```

### Output
Berdasarkan code tersebut, maka ditemukan hasil sebagai berikut.
1. Titik Penting
```bash
node_001,Point1,-7.920000,112.450000
node_002,Point2,-7.920000,112.468100
node_003,Point3,-7.937960,112.468100
node_004,Point4,-7.937960,112.450000
```
2. Posisi Pusaka
``` bash
Koordinat pusat:
-7.92898 112.459
```

### Problem
1. Data tidak langsung terlihat karena tersembunyi di dalam file PDF, sehingga sempat membingungkan dalam menentukan langkah awal pengerjaan.
2. Terjadi kesalahan pada penggunaan perintah, seperti typo saat melakukan git clone, serta folder tujuan yang sudah ada sehingga proses clone gagal.
3. Sempat terjadi kesalahan path saat berpindah direktori, sehingga beberapa file tidak dapat diakses atau terbaca.
4. Hasil parsing awal belum sesuai karena format data JSON belum dibersihkan dengan benar, sehingga output masih berantakan.
5. File output sempat tidak terbentuk karena script belum dijalankan dengan benar atau belum diberikan permission.
6. Setelah dilakukan perbaikan pada perintah, path, dan script parsing, seluruh proses akhirnya dapat berjalan dengan baik dan menghasilkan output yang sesuai

## Soal 3
### Solve Code
1. Membuat Mode Cron untuk menjalankan program secara otomatis tanpa menu.
```bash
if [ "$1" == "--check-tagihan" ]; then
    while IFS=, read -r nama kamar harga tanggal status
    do
        if [ "$status" == "Menunggak" ]; then
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] TAGIHAN: $nama (Kamar $kamar) - Menunggak Rp$harga" >> log/tagihan.log
        fi
    done < data/penghuni.csv
    exit
fi
```
2. Pembuatan Folder dan file
```bash
DATA="data/penghuni.csv"
HISTORY="sampah/history_hapus.csv"
LAPORAN="rekap/laporan_bulanan.txt"
LOG="log/tagihan.log"

mkdir -p data sampah rekap log
touch $DATA $HISTORY $LAPORAN $LOG
```
3. Membuat menu utama menggunakan while loop
4. Tambah penghuni dengan menginput data dan disimpan ke file penghuni.csv
```bash
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
'''
5. Menghapus data penghuni yang dimana data terhapus akan dipindahkan ke file history_hapus.csv
'''bash
read -p "Nama yang dihapus: " nama

grep -i "$nama" $DATA >> $HISTORY
sed -i "/$nama/d" $DATA

echo "[✓] Data dipindahkan ke sampah"
'''
6. Tampilkan data penghuni
'''bash
awk -F',' '{
printf "%-3s | %-10s | %-5s | Rp%-10s | %-10s\n", NR, $1, $2, $3, $5
}' $DATA

total=$(wc -l < $DATA)
aktif=$(grep -c "Aktif" $DATA)
nunggak=$(grep -c "Menunggak" $DATA)

echo "----------------------------------------------"
echo "Total: $total | Aktif: $aktif | Menunggak: $nunggak"
```
7. Update status penghuni tanpa mengubah data lainnya
```bash
read -p "Nama: " nama
read -p "Status baru (Aktif/Menunggak): " status

sed -i "s/^$nama,\([^,]*\),\([^,]*\),\([^,]*\),.*/$nama,\1,\2,\3,$status/" $DATA

echo "[✓] Status berhasil diupdate"
```
8. Membuat laporan dengan menghitung jumlah ppenghuni aktif dan menunggak dan total pemasukan menggunakan grep dan awk
```bash
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
```
9. Membuat kelola cron untuk melihat, menambah dan menghapus cron job
```bash
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

(crontab -l 2>/dev/null; echo "$menit $jam * * * $path --check-tagihan") | crontab -

echo "[✓] Cron berhasil ditambahkan"
;;
3)
crontab -r
echo "[✓] Cron berhasil dihapus"
;;
esac
```

### Output
1. Penghuni.csv
```bash
Naurah	1	1600000	2026-03-24	Aktif
Gege	3	1600000	2026-03-30	Aktif
```
2. Laporan
```bash
LAPORAN KOST
Aktif: Rp4800000
Tunggakan: Rp
Jumlah: 3
```
3. Hapus Data
```bash
Merry	4	1600000	2026-08-19	Menunggak
```

### Problem
1. Pada awal pembuatan script, terdapat kesalahan syntax seperti penulisan if tanpa spasi yang menyebabkan program tidak dapat dijalankan.
2. Sempat terjadi kesalahan pada penulisan path file, sehingga data tidak terbaca atau tidak tersimpan pada folder yang seharusnya.
3. Pada fitur update dan hapus data, terdapat error karena typo pada nama file atau variabel, sehingga perubahan tidak berhasil dilakukan.
4. Output tampilan awal kurang rapi karena belum menggunakan formatting yang tepat pada awk.
5. Pada bagian cron job, awalnya tidak berjalan dengan baik karena script belum menangani parameter --check-tagihan.
7. Cron sempat tidak muncul atau tidak sesuai karena kesalahan dalam penulisan perintah dan pengaturan jadwal.
8. File log tidak terisi karena kondisi data (status “Menunggak”) tidak terpenuhi atau script tidak berjalan sesuai mode cron.
9. Sempat terjadi kehilangan isi file akibat kesalahan saat menyimpan atau mengedit script.

## Revisi
Terjadi error pada crontab saat menambahkan jam yang dimana awalnya tidak bisa menambahkan menit di atas 30 dikarenakan pemanggilan $jam dan $menit terbalik (seharusnya $menit baru $jam), sehingga jika melebihi dari 30 menit maka akan mengeluarkan pesan bad hours.
