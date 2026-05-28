function Details_thresh = haar_threshold(Details, tau)
Details_thresh = Details;
[levels, ~] = size(Details);
for i = 1:levels
    for j = 1:3
        coeff = Details{i, j};
        coeff(abs(coeff) < tau) = 0; % Cắt ngưỡng cứng
        Details_thresh{i, j} = coeff;
    end
end
end