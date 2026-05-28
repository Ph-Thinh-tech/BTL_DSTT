function img_recon = haar_reconstruct(LL, Details, level)
img_recon = LL;
for i = level:-1:1
    HL = Details{i, 1};
    LH = Details{i, 2};
    HH = Details{i, 3};

    [m, n] = size(img_recon);
    temp = zeros(2*m, 2*n);

    A = (img_recon + HL + LH + HH) / 2;
    B = (img_recon + HL - LH - HH) / 2;
    C = (img_recon - HL + LH - HH) / 2;
    D = (img_recon - HL - LH + HH) / 2;

    temp(1:2:end, 1:2:end) = A;
    temp(1:2:end, 2:2:end) = B;
    temp(2:2:end, 1:2:end) = C;
    temp(2:2:end, 2:2:end) = D;

    img_recon = temp;
end
end