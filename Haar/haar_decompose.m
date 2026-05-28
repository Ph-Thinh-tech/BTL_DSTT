function [LL, detailArr] = haar_decompose(img, level)
    LL = double(img);
    detailArr = cell(level, 3); 
    
    for i = 1:level
        [rows, cols] = size(LL);
        
        LL = LL(1:2*floor(rows/2), 1:2*floor(cols/2));

        A = LL(1:2:end, 1:2:end);
        B = LL(1:2:end, 2:2:end);
        C = LL(2:2:end, 1:2:end);
        D = LL(2:2:end, 2:2:end);
        
        LLNew = (A + B + C + D) / 2;
        HL = (A + B - C - D) / 2;
        LH = (A - B + C - D) / 2;
        HH = (A - B - C + D) / 2;
        
        detailArr{i, 1} = HL;
        detailArr{i, 2} = LH;
        detailArr{i, 3} = HH;
        
        LL = LLNew; 
    end
end