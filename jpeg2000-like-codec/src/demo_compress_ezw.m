function demo_compress_ezw
postfix = 'test';
img_in = '../images/Lena.bmp';
num_pass = 10;
file_out = sprintf('../images/LenaEZW%02d%s.dat', num_pass, postfix);
file_in = file_out;
bpp_target = 0.5;
img_out = sprintf('../images/LenaEZW%02d%s.png', num_pass, postfix);
if exist(file_out) == 0,
    compress(img_in, bpp_target, file_out);
end
if exist(img_out) == 0,
    decompress(file_in, img_out);
end

% plot bpp vs psnr
A = double(imgread(img_in));
[nRow, nCol] = size(A);
file_out = sprintf('../images/LenaEZW%02d%s.dat', num_pass, postfix);
file_in;
eval(sprintf('load %s -mat', file_in));
total_bits = 0;
for i=1:num_pass
    bits = 8 * (length(huffman_sigs{i}) + length(huffman_refs{i}));
    total_bits = total_bits + bits;
    bpp = total_bits / (nRow * nCol);
    bpps(i) = bpp;
    
    % Intermediate state X
    eval(sprintf('load %s.%02dof%02d -mat', file_in, i, num_pass)); % X
    % Inverse Wavelet
    addpath matlabPyrTools/
    addpath matlabPyrTools/MEX/
    I = invwave_transform_qmf(X,5); % qmf5
    % add DC coponent
    I = I + dc;
    psnrs(i) = psnr(A, I);
    
    I = uint8(I);
    img_out = sprintf('../images/LenaEZW%02dof%02d%s.png', i, num_pass, postfix);
    imwrite(uint8(I), img_out);
end
bpps
psnrs
%figure;
hold on;
plot(bpps, psnrs, '-k');
% title('BPP vs PSNR for EZW-Based Encoding');
xlabel('bpp (bits per pixel)');
ylabel('PSNR in dB');
    