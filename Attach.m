// This file is only to have a way to easily generate all sig files.
// This is needed to circumvent a magma bug in v2.29-4 (and likely other version).
// This bug is triggered when multiple processes attach the same spec file at the same time.
AttachSpec("TwistParametrized.spec");
quit;
