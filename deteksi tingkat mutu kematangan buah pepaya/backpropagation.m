clc; clear; close all; warning off all;

% membaca data asli dari file excel
data_asli = xlsread('Data pengujian 3.xlsx',1,'F7:Y66');
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
data_latih = 2  % citra pepaya 13 s.d citra pepaya 24
jumlah_citrapepaya = 60;
data_latih_norm = zeros(jumlah_citrapepaya*data_latih-jumlah_citrapepaya,jumlah_citrapepaya);
% menyusun data latih normalisasi
for m = 1:jumlah_citrapepaya*data_latih-jumlah_citrapepaya
    for n = 1:jumlah_citrapepaya
        data_latih_norm(m,n) = data_norm(m+n-1);
    end
end

% menyiapkan target latih normalisasi
target_latih_norm = zeros(jumlah_citrapepaya*data_latih-jumlah_citrapepaya,1);
for m = 1:jumlah_citrapepaya*data_latih-jumlah_citrapepaya
    target_latih_norm(m) = data_norm(jumlah_citrapepaya+m);    %  citra pepaya 44
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




