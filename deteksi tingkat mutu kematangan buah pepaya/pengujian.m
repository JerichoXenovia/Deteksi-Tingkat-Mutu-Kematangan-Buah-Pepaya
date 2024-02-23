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

% menyiapkan data latih normalisasi 
data_latih = 2  % citra lambung 2 s.d citra lambung 5
jumlah_citralambung = 12;
data_latih_norm = zeros(jumlah_citralambung*data_latih-jumlah_citralambung,jumlah_citralambung);
% menyusun data latih normalisasi
for m = 1:jumlah_citralambung*data_latih-jumlah_citralambung
    for n = 1:jumlah_citralambung
        data_latih_norm(m,n) = data_norm(m+n-1);
    end
end

% menyiapkan target latih normalisasi
target_latih_norm = zeros(jumlah_citralambung*data_latih-jumlah_citralambung,1);
for m = 1:jumlah_citralambung*data_latih-jumlah_citralambung
    target_latih_norm(m) = data_norm(jumlah_citralambung+m);    %  citra lambung 5
end

% melakukan transpose terhadap data latih normalisasi dan target latih 
% normalisasi
data_latih_norm = data_latih_norm';
target_latih_norm = target_latih_norm';

% menetapkan parameter JST
jumlah_neuron1 = 100;
fungsi_aktivasi1 = 'logsig';
fungsi_aktivasi2 = 'logsig';
fungsi_pelatihan = 'traingd';

% membangun arsitek JST backpropagation
rng('default')
jaringan = newff(minmax(data_latih_norm),[jumlah_neuron1 1],...
    {fungsi_aktivasi1,fungsi_aktivasi2},fungsi_pelatihan);

% melakukan pelatihan jaringan
jaringan = train(jaringan,data_latih_norm,target_latih_norm);

% membaca hasil pelatihan
hasil_latih_norm = sim(jaringan,data_latih_norm);




