itrs=30
flags="-q -s 8"
schema="songdb.sql albums2.sql artists2.sql songs2.sql tags2.sql users2.sql usersongplays2.sql usersongratings2.sql"

# set -x

echo system
../../bin/sqlite/sqlite3-test $itrs $flags $schema > ../../results/sqlite/system.txt

echo mem3
../../bin/sqlite/sqlite3-mem3-test $itrs $flags $schema > ../../results/sqlite/mem3.txt

echo mem5
../../bin/sqlite/sqlite3-mem5-test $itrs $flags $schema > ../../results/sqlite/mem5.txt

export DYLD_FORCE_FLAT_NAMESPACE=1
export DYLD_INSERT_LIBRARIES=../../Replace-Libs/libhoard.dylib
echo hoard
../../bin/sqlite/sqlite3-test $itrs $flags $schema > ../../results/sqlite/hoard.txt

export DYLD_INSERT_LIBRARIES=../../Replace-Libs/libtlsf.dylib
echo tlsf
../../bin/sqlite/sqlite3-test $itrs $flags $schema > ../../results/sqlite/tlsf.txt

export DYLD_FORCE_FLAT_NAMESPACE=
export DYLD_INSERT_LIBRARIES=