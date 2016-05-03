class Strainphlan < Formula
  desc "StrainPhlAn"
  homepage "https://bitbucket.org/biobakery/metaphlan2"
  url "https://bitbucket.org/biobakery/metaphlan2/get/e82c52bf0f427fc4926292f8f4549519441fb85d.tar.gz"
  version "2.5.0-e82c52b"
  sha256 "b9480aa55d948022ea31e1298802db256f03b05c8b44effde5d12e99f7b704bb"

  # add the option to build without python
  option "without-python", "Build without python2 support"
  depends_on :python => :recommended if MacOS.version <= :snow_leopard

  depends_on "homebrew/science/bowtie2" => [:recommended, "without-tbb"]
  depends_on "homebrew/science/blast" => :recommended
  depends_on "homebrew/science/muscle" => :recommended
  depends_on "homebrew/science/vcftools" => :recommended

  resource "biom-format" do
    url "https://pypi.python.org/packages/source/b/biom-format/biom-format-1.3.1.tar.gz"
    sha256 "03e750728dc2625997aa62043adaf03643801ef34c1764213303e926766f4cef"
  end

  resource "numpy" do
    url "https://pypi.python.org/packages/source/n/numpy/numpy-1.11.0.tar.gz"
    sha256 "a1d1268d200816bfb9727a7a27b78d8e37ecec2e4d5ebd33eb64e2789e0db43e"
  end

  resource "pandas" do
    url "https://pypi.python.org/packages/source/p/pandas/pandas-0.13.1.tar.gz"
    sha256 "6813746caa796550969ed98069f16627f070f6d8d60686cfb3fa0e66c2e0312b"
  end

  resource "msgpack" do
    url "https://pypi.python.org/packages/source/m/msgpack-python/msgpack-python-0.4.7.tar.gz"
    sha256 "5e001229a54180a02dcdd59db23c9978351af55b1290c27bc549e381f43acd6b"
  end

  resource "pysam" do
    url "https://pypi.python.org/packages/source/p/pysam/pysam-0.9.0.tar.gz"
    sha256 "90edf568835245e03eea176196cfafdfcb3af7e5fb40e48923a63f75c266c03c"
  end

  resource "biopython" do
    url "https://pypi.python.org/packages/source/b/biopython/biopython-1.65.tar.gz"
    sha256 "6d591523ba4d07a505978f6e1d7fac57e335d6d62fb5b0bcb8c40bdde5c8998e"
  end

  resource "dendropy" do
    url "https://pypi.python.org/packages/source/D/DendroPy/DendroPy-4.1.0.tar.gz"
    sha256 "c3d4b2780b84fb6ad64a8350855b2d762cabe45ecffbc04318f07214ee3bdfc9"
  end

  resource "raxml" do
    url "https://github.com/stamatak/standard-RAxML/archive/v8.1.15.tar.gz"
    sha256 "f0388f6c5577006dc13e2dc8c35a2e5046394f61009ec5b04fb09254f8ec25b2"
  end

  def install
    # install metaphlan2_strainer
    ENV.prepend "PYTHONPATH", prefix, ':'
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    ENV.prepend_create_path 'PYTHONPATH', libexec/"lib64/python2.7/site-packages"
    
    prefix.install Dir["*"]
    bin.install Dir[prefix/"*.py"]
    bin.install Dir[prefix/"strainer_src/*.py"]
    bin.env_script_all_files(prefix, :PYTHONPATH => ENV["PYTHONPATH"])
    bin.install_symlink prefix/"db_v20"

    # install after metaphlan2_strainer files as these will be installed in
    # bin and we do not want to env_script these files
    # install before numpy so as to not have LDFLAGS set to shared
    # install raxml and also SSE3, both are required
    resource("raxml").stage do
      system "make", "-f", "Makefile.PTHREADS.gcc"
      rm Dir["*.o"]
      system "make", "-f", "Makefile.SSE3.PTHREADS.gcc"
      bin.install Dir["raxml*"]
    end
    
    # update LDFLAGS for numpy install
    ENV.append "LDFLAGS", "-shared" if OS.linux?
    %w[numpy pandas biom-format msgpack pysam biopython dendropy].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec)
      end
    end
  end

  test do
    system "#{bin}/metaphlan2.py", "--version"
  end
end