function haar()
imgPath = 'D:\BTL_DSTT\Haar\dog.jpg';
if ~isfile(imgPath)
    error('File not found. Please verify the absolute path.');
end

img = imread(imgPath);
if size(img, 3) == 3
    img = rgb2gray(img);
end
X = double(img);

[rows, cols] = size(X);
X = X(1:2*floor(rows/2), 1:2*floor(cols/2));

A = X(1:2:end, 1:2:end);
B = X(1:2:end, 2:2:end);
C = X(2:2:end, 1:2:end);
D = X(2:2:end, 2:2:end);

LL = (A + B + C + D) / 2;
HL = (A + B - C - D) / 2;
LH = (A - B + C - D) / 2;
HH = (A - B - C + D) / 2;

thresholds = [10, 30, 50];

figure('Position', [100, 100, 1200, 400]);
subplot(1, length(thresholds) + 1, 1);
imshow(uint8(X));
title('Original Image');

for i = 1:length(thresholds)
    tau = thresholds(i);

    LH_thresh = hard_threshold(LH, tau);
    HL_thresh = hard_threshold(HL, tau);
    HH_thresh = hard_threshold(HH, tau);

    total_coeffs = numel(LH) + numel(HL) + numel(HH);
    zero_coeffs = sum(LH_thresh(:) == 0) + sum(HL_thresh(:) == 0) + sum(HH_thresh(:) == 0);
    sparsity = (zero_coeffs / total_coeffs) * 100;

    [m, n] = size(LL);
    X_recon = zeros(2*m, 2*n);

    X_recon(1:2:end, 1:2:end) = (LL + HL_thresh + LH_thresh + HH_thresh) / 2; % A
    X_recon(1:2:end, 2:2:end) = (LL + HL_thresh - LH_thresh - HH_thresh) / 2; % B
    X_recon(2:2:end, 1:2:end) = (LL - HL_thresh + LH_thresh - HH_thresh) / 2; % C
    X_recon(2:2:end, 2:2:end) = (LL - HL_thresh - LH_thresh + HH_thresh) / 2; % D

    X_recon = max(min(X_recon, 255), 0);

    mse_val = mean((X(:) - X_recon(:)).^2);
    psnr_val = 10 * log10((255^2) / mse_val);

    subplot(1, length(thresholds) + 1, i + 1);
    imshow(uint8(X_recon));
    title(sprintf('\\tau = %d\nPSNR: %.2f dB\nSparsity: %.1f%%', tau, psnr_val, sparsity));
end
end

function coeff_thresh = hard_threshold(coeff, tau)
coeff_thresh = coeff;
coeff_thresh(abs(coeff) < tau) = 0;
end