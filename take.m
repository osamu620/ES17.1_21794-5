function [bitstream_r, bitstream_i,...
    num_passes_r, num_passes_i,...
    pass_length_r, pass_length_i,...
    codestream_bytes] = take(TB)

for i = 1:16
    for j = 1:16
        [c,b,xm]=takeTB(TB, i, j);
        coeff((i-1)*256+1:i*256, (j-1)*256+1:j*256) = c;
        bd((i-1)*64+1:i*64, (j-1)*64+1:j*64) = b;
        xmax((i-1)*64+1:i*64, (j-1)*64+1:j*64) = xm;
    end
end

codestream_bytes = 0;
f = waitbar(0,'1','Name','Compressing data...',...
    'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');

for i = 1:64
    for j = 1:64
        waitbar((i*64+j)/4096,f,sprintf('y = %02d/64 x = %02d/64',i,j))
        block = coeff((i-1)*64+1:i*64, (j-1)*64+1:j*64);
        rp = real(block);
        ip = imag(block);
        [bitstream_r{i,j}, num_passes_r{i,j}, pass_length_r{i,j}] = HT_block_encode_mex(int32(real(block)), int32(0), uint16(0));
        [bitstream_i{i,j}, num_passes_i{i,j}, pass_length_i{i,j}] = HT_block_encode_mex(int32(imag(block)), int32(0), uint16(0));
        codestream_bytes = codestream_bytes + pass_length_r{i,j} + pass_length_i{i,j};
    end
end

delete(f);