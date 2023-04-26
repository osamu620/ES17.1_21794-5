prepare_test;

[nblow, tlow] = do_ec_htj2k("low", LOW, "~/Documents/Clone/WG1/OpenHTJ2K/build-relwithdebinfo/bin");
[nbmed, tmed] = do_ec_htj2k("medium", MEDIUM, "~/Documents/Clone/WG1/OpenHTJ2K/build-relwithdebinfo/bin");
[nbhigh, thigh] = do_ec_htj2k("high", HIGH, "~/Documents/Clone/WG1/OpenHTJ2K/build-relwithdebinfo/bin");

csize = [nblow, nbmed, nbhigh];
t = [tlow, tmed, thigh];