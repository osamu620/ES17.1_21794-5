function [QB, bd, xmax] = takeQB(in,y,x)

for i = 1:64
    for j = 1:64
        bd(i,j) = in(y,x).QuantizationBlock(i,j).bitdepth;
        xmax(i,j) = in(y,x).QuantizationBlock(i,j).xmax;
        QB((i-1)*4+1:i*4,(j-1)*4+1:j*4) = reshape(in(y,x).QuantizationBlock(i,j).coeff,4,4);
    end
end