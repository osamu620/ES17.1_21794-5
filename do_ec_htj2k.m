function [numbytes, type] = do_ec_htj2k(type, TRANSFORMBLOCK, ohtj2kpath, multithread)
%
% Usage: [numbytes, time] = do_ec_htj2k(type, TRANSFORMBLOCK, path-to-codec)
%
% type: "low" or "medium", or "high"
% time is in [ms]


base_name = '';
if strcmpi("low", type)
    base_name = "low";
elseif strcmpi("medium", type)
    base_name = "medium";
elseif strcmpi("high", type)
    base_name = "high";
else
    error('input arg shall be "low" or "medium" or "high');
end

if nargin < 3
    ohtj2kpath = "/Users/osamu/Documents/Clone/WG1/OpenHTJ2K/build-relwithdebinfo/bin";
    multithread = false;
end

j2kop = 'Creversible=yes Clevels=0 Cprecincts="{256,256}" Corder="RPCL"';
if multithread == true
    j2kop = sprintf("%s -numthread 0", j2kop);
else
    j2kop = sprintf("%s -numthread 1", j2kop);
end

for i = 1:16
    for j = 1:16
        [c,b,xm]=takeTB(TRANSFORMBLOCK, i, j);
        coeff((i-1)*256+1:i*256, (j-1)*256+1:j*256) = c;
        bd((i-1)*64+1:i*64, (j-1)*64+1:j*64) = b;
        xmax((i-1)*64+1:i*64, (j-1)*64+1:j*64) = xm;
    end
end
rc = real(coeff);
ic = imag(coeff);
rc(rc == -1) = 0;
ic(ic == -1) = 0;
write_pgx(sprintf("real-%s.pgx", base_name), rc, 1, 12);
write_pgx(sprintf("imag-%s.pgx", base_name), ic, 1, 12);
write_pgx(sprintf("bd-%s.pgx", base_name), bd, 1, 8);
write_pgx(sprintf("xmax-%s.pgx", base_name), xmax, 1, 12);

%% Encoding
fname0 = sprintf("real-%s", base_name);
fname1 = sprintf("imag-%s", base_name);
fname2 = sprintf("bd-%s", base_name);
fname3 = sprintf("xmax-%s", base_name);
time = 0;
command = sprintf("%s/open_htj2k_enc -i %s.pgx -o %s.j2c %s", ohtj2kpath, fname0, fname0, j2kop);
[~,cmdout] = system(command); a = textscan(cmdout, '%s'); time = time + str2double(cell2mat(a{1}(35)));
command = sprintf("%s/open_htj2k_enc -i %s.pgx -o %s.j2c %s", ohtj2kpath, fname1, fname1, j2kop);
[~,cmdout] = system(command); a = textscan(cmdout, '%s'); time = time + str2double(cell2mat(a{1}(35)));
command = sprintf("%s/open_htj2k_enc -i %s.pgx -o %s.j2c %s", ohtj2kpath, fname2, fname2, j2kop);
[~,cmdout] = system(command); a = textscan(cmdout, '%s'); time = time + str2double(cell2mat(a{1}(35)));
command = sprintf("%s/open_htj2k_enc -i %s.pgx -o %s.j2c %s", ohtj2kpath, fname3, fname3, j2kop);
[~,cmdout] = system(command); a = textscan(cmdout, '%s'); time = time + str2double(cell2mat(a{1}(35)));

%% Gathering codestream size
info = dir(sprintf('*-%s.j2c', base_name));
[n, ~] = size(info);
numbytes = 0;
for i = 1:n
    numbytes = numbytes + info(i).bytes;
end
%% Decoding
command = sprintf("%s/open_htj2k_dec -i %s.j2c -o %s-dec.pgx", ohtj2kpath, fname0, fname0);
[~,cmdout] = system(command);
command = sprintf("%s/open_htj2k_dec -i %s.j2c -o %s-dec.pgx", ohtj2kpath, fname1, fname1);
[~,cmdout] = system(command);
command = sprintf("%s/open_htj2k_dec -i %s.j2c -o %s-dec.pgx", ohtj2kpath, fname2, fname2);
[~,cmdout] = system(command);
command = sprintf("%s/open_htj2k_dec -i %s.j2c -o %s-dec.pgx", ohtj2kpath, fname3, fname3);
[~,cmdout] = system(command);

%% Checking
t0 = read_pgx(sprintf("%s-dec_00.pgx", fname0));
if ~isequal(t0, rc)
    fprintf(sprintf("%s has error\n", fname0));
end
t0 = read_pgx(sprintf("%s-dec_00.pgx", fname1));
if ~isequal(t0, ic)
    fprintf(sprintf("%s has error\n", fname1));
end
t0 = read_pgx(sprintf("%s-dec_00.pgx", fname2));
if ~isequal(t0, bd)
   fprintf(sprintf("%s has error\n", fname2));
end
t0 = read_pgx(sprintf("%s-dec_00.pgx", fname3));
if ~isequal(t0, xmax)
   fprintf(sprintf("%s has error\n", fname3));
end

fprintf("codestream-bytes: %d\n", numbytes);
fprintf("time for encoding: %f [ms]\n", time);