clc; clear; close all; warning off all;

% membaca data asli dari file excel
data_asli = xlsread('Citra Lambung draft',1,'C4:V15');
% melakukan transpose terhadap data asli
data_asli = data_asli';
% mengubah matriks menjadi bentuk vektor
data_asli = data_asli(:);
% mencari nilai min dan max dari data asli
min_data = min(data_asli);
max_data = max(data_asli);
% proses normalisasi data
[m,n] = size(data_asli);
data_norm = zeros(m,n)
for x = 1:m
    for y = 1:n
        data_norm(x,y) = (data_asli(x,y)-min_data)/(max_data-min_data);
    end
end

% menyiapkan data uji normalisasi
data_latih = 2;     % citra lambung 2 s.d citra lambung 5
data_uji = 2;       % citra lambung 2 s.d citra lambung 7
jumlah_citralambung = 12;
data_uji_norm = zeros(jumlah_citralambung*data_uji-jumlah_citralambung,jumlah_citralambung); 
% menyusun data uji normalisasi
for m = 1:jumlah_citralambung*data_uji-jumlah_citralambung
    for n = 1:jumlah_citralambung
        data_uji_norm(m,n) = data_norm(m+n-1+(data_latih-1)*jumlah_citralambung); % citra lambung 2 s.d citra lambung 7
    end
end

% menyiapkan target uji normalisasi
target_uji_norm = zeros(jumlah_citralambung*data_uji-jumlah_citralambung,1);
for m = 1:jumlah_citralambung*data_uji-jumlah_citralambung
    target_uji_norm(m) = data_norm(jumlah_citralambung+m+(data_uji-1)*jumlah_citralambung); % citra lambung 7
end
    
% melakukan transpose terhadap data uji normalisasi dan target uji
% normalisasi
data_uji_norm = data_uji_norm';
target_uji_norm = target_uji_norm';

% memanggil arsitektur JST hasil pelatihan
load jaringan

% membaca hasil pengujian
hasil_uji_norm = sim(jaringan,data_uji_norm);

% melakukan denormalisasi terhadap hasil uji normalisasi
hasil_uji_asli = round(hasil_uji_norm*(max_data-min_data)+min_data);

% membaca target uji asli
target_uji_asli = data_asli(jumlah_citralambung+1+(data_latih-1)*jumlah_citralambung:...
    jumlah_citralambung*data_uji+(data_latih-1)*jumlah_citralambung);

% menghitung nilai error MSE
nilai_error = hasil_uji_norm-target_uji_norm;
error_MSE = (1/n)*sum(nilai_error.^2);

% menampilkan grafik hasil pengujian
figure
plot(hasil_uji_asli,'ko-','LineWidht',2)
hold on
plot(hasil_uji_asli,'go-','LineWidht',2)
grid on
title(['Grafik Keluaran JST vs Target dengan nilai MSE = ',num2str(error_MSE)])
xlabel('citra lambung 7')
ylabel('Ukur Citra (mm/pixel)')
legend('Keluaran JST','Target')
hold off

% menyiapkan data prediksi normalisasi
data_prediksi_norm = hasil_uji_norm(end-11:end);
% melakukan transpose terhadap data prediksi normalisasi
data_prediksi_norm = data_prediksi_norm';

% melakukan prediksi
hasil_prediksi_norm = sim(jaringan,data_prediksi_norm);     % citra lambung 8

for n = 1:11
    data_prediksi_norm = [data_prediksi_norm(end-10:end);hasil_prediksi_norm(end)];
    hasil_prediksi_norm = [hasil_prediksi_norm,sim(jariingan,data_prediksi_norm)];
end

% melakukan denormalisasi terhadap hasil prediksi normalisasi
hasil_prediksi_asli = roudn(hasil_prediksi_norm*(max_data-min_data)+min_data);

% menampilkan grafik hasil prediksi
figure
plot(hasil_prediksi_asli,'mo-','LineWidht',2)
grid on
title('Grafik Keluaran JST')
xlabel('citra lambung 8')
ylabel('Ukur Citra (mm/pixel')
legend('Keluaran JST')