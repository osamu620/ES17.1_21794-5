if ~(exist('LOW', 'var') && exist('MEDIUM', 'var') && exist('HIGH', 'var'))
    prepare_test;
end

N = 10;
for i = 1:N
    [nblow, tlow] = do_ec_htj2k("low", LOW, "~/Documents/Clone/WG1/OpenHTJ2K/build-relwithdebinfo/bin");
    [nbmed, tmed] = do_ec_htj2k("medium", MEDIUM, "~/Documents/Clone/WG1/OpenHTJ2K/build-relwithdebinfo/bin");
    [nbhigh, thigh] = do_ec_htj2k("high", HIGH, "~/Documents/Clone/WG1/OpenHTJ2K/build-relwithdebinfo/bin");

    csize_s = [nblow, nbmed, nbhigh];
    t_s(i, :) = [tlow, tmed, thigh];
end

for i = 1:N
    [nblow, tlow] = do_ec_htj2k("low", LOW, "~/Documents/Clone/WG1/OpenHTJ2K/build-relwithdebinfo/bin", true);
    [nbmed, tmed] = do_ec_htj2k("medium", MEDIUM, "~/Documents/Clone/WG1/OpenHTJ2K/build-relwithdebinfo/bin", true);
    [nbhigh, thigh] = do_ec_htj2k("high", HIGH, "~/Documents/Clone/WG1/OpenHTJ2K/build-relwithdebinfo/bin", true);

    csize_m = [nblow, nbmed, nbhigh];
    t_m(i, :) = [tlow, tmed, thigh];
end

