function [coeff,bd,xmax] = takeTB(in, y,x)

coeff = in(y,x).EasyAccess.coeff;
bd = in(y,x).EasyAccess.bitdepth;
xmax = in(y,x).EasyAccess.xmax;
