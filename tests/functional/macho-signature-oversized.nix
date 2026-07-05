with import ./config.nix;

# A single-output derivation containing a file that carries Mach-O
# magic but exceeds the parser's file-size bound. The real bound is
# 4 GiB (the 32-bit codeLimit format limit); the test shrinks it via
# _NIX_TEST_MACHO_MAX_FILE_SIZE so the fixture stays small. Such a
# file is reported `Unchecked` by the daemon-side scan and failed by
# the check child — it can never be verified, only refused or waved
# through with a warning.

mkDerivation {
  name = "macho-signature-oversized";
  buildCommand = ''
    mkdir -p "$out"
    # 1 MiB + 1 byte, starting with MH_MAGIC_64; the test caps the
    # parser at 1 MiB.
    printf '\xcf\xfa\xed\xfe' > "$out/big"
    dd if=/dev/zero of="$out/big" bs=1 count=1 seek=1048576 conv=notrunc 2>/dev/null
  '';
}
