# Define custom utilities
# Test for macOS with [ -n "$IS_OSX" ]

function pre_build {
    # Any stuff that you need to do before you start building the wheels
    # Runs in the root directory of this repository.
    yum install -y wget ninja boost-devel lapack-devel tinyxml2-devel

    # Install stuff to
    pip install numpy

    # Build and install Dakota
    srcdir=$PWD/dakota-6.12-release-public.src

    wget https://dakota.sandia.gov/sites/default/files/distributions/public/dakota-6.12-release-public.src.tar.gz
    tar xf ${srcdir}.tar.gz
    mkdir dakota-build
    pushd dakota-build

    cmake $srcdir -GNinja
    ninja install

    popd
}

function run_tests {
    # Runs tests on installed distribution from an empty directory

    # pytest adds every directory up-to and including python/ into sys.path,
    # meaning that "import ecl" will import python/ecl and not the installed
    # one. This doesn't work because the libecl.so library only exists in
    # site-packages, so we copy directories required by the tests out into its
    # own temporary directory.
    mkdir -p {.git,python}
    ln -s {..,$PWD}/bin
    ln -s {..,$PWD}/lib
    ln -s {..,$PWD}/test-data
    cp -R {..,$PWD}/python/tests
    python -m pytest python/tests
}
