class Metaphlan2 < Formula
  desc "MetaPhlAn 2.0: Metagenomic Phylogenetic Analysis"
  homepage "https://bitbucket.org/biobakery/metaphlan2"
  url "https://bitbucket.org/biobakery/metaphlan2/get/c07beded1dc3a7eb7a1f8434c6ec7325a48d1675.tar.gz"
  version "2.3.0-c07bede"
  sha256 "1e697b2c5fc2ad8131f7e9aa035aea19da7e31089d6b761d9555052e6119b3d4"

  # add the option to build without python
  option "without-python", "Build without python2 support"
  depends_on :python => :recommended if MacOS.version <= :snow_leopard

  depends_on "homebrew/science/bowtie2" => [:recommended, "without-tbb"]

  # matplotlib on some platforms requires homebrew freetype
  depends_on "freetype" => :recommended

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

  resource "biopython" do
    url "https://pypi.python.org/packages/source/b/biopython/biopython-1.65.tar.gz"
    sha256 "6d591523ba4d07a505978f6e1d7fac57e335d6d62fb5b0bcb8c40bdde5c8998e"
  end

  resource "pyqi" do
    url "https://pypi.python.org/packages/source/p/pyqi/pyqi-0.3.2.tar.gz"
    sha256 "8f1711835779704e085e62194833fed9ac2985e398b4ceac6faf6c7f40f5d15f"
  end

  resource "scipy" do
    url "https://pypi.python.org/packages/source/s/scipy/scipy-0.12.0.tar.gz"
    sha256 "b967e802dafe2db043cfbdf0043e1312f9ce9c1386863e1c801a08ddfccf9de6"
  end

  resource "matplotlib" do
    url "https://pypi.python.org/packages/source/m/matplotlib/matplotlib-1.5.1.tar.gz"
    sha256 "3ab8d968eac602145642d0db63dd8d67c85e9a5444ce0e2ecb2a8fedc7224d40"
  end

  resource "hclust" do
    url "https://bitbucket.org/nsegata/hclust2/get/277c0d6a1d52.tar.gz"
    sha256 "4596de8fd0a7bb6536e9b7dfd39ca732376044c34416513cafa72918ec818038"
  end

  resource "pyparsing" do
    url "https://pypi.python.org/packages/94/51/3dd26b41be55ed05e72d1da87e4a732d8b92245b1f2f7fe2fa65a4910858/pyparsing-2.1.1.tar.gz"
    sha256 "9bae5cd4cbee6da0d7d8d9a1647f5253a3b89652e707647eaf1961f4932ae6c6"
  end

  resource "pytz" do
    url "https://pypi.python.org/packages/ad/30/5ab2298c902ac92fdf649cc07d1b7d491a241c5cac8be84dd84464db7d8b/pytz-2016.4.tar.gz"
    sha256 "c823de61ff40d1996fe087cec343e0503881ca641b897e0f9b86c7683a0bfee1"
  end

  resource "dateutil" do
    url "https://pypi.python.org/packages/3e/f5/aad82824b369332a676a90a8c0d1e608b17e740bbb6aeeebca726f17b902/python-dateutil-2.5.3.tar.gz"
    sha256 "1408fdb07c6a1fa9997567ce3fcee6a337b39a503d80699e0f213de4aa4b32ed"
  end

  resource "cycler" do
    url "https://pypi.python.org/packages/c2/4b/137dea450d6e1e3d474e1d873cd1d4f7d3beed7e0dc973b06e8e10d32488/cycler-0.10.0.tar.gz"
    sha256 "cd7b2d1018258d7247a71425e9f26463dfb444d411c39569972f4ce586b0c9d8"
  end


  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    ENV.prepend_create_path 'PYTHONPATH', libexec/"lib64/python2.7/site-packages"

    # update LDFLAGS for numpy install
    ENV.append "LDFLAGS", "-shared" if OS.linux?
    %w[numpy pandas scipy matplotlib biopython pyqi biom-format pyparsing pytz dateutil cycler].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec)
      end
    end

    # install hclust
    libexec.install resource("hclust")
    bin.install libexec/"hclust2.py"

    prefix.install Dir["*"]
    bin.install prefix/"metaphlan2.py"
    bin.install Dir[prefix/"utils/*"]
    bin.env_script_all_files(prefix, :PYTHONPATH => ENV["PYTHONPATH"])
    bin.install_symlink prefix/"db_v20"
  end

  test do
    system "#{bin}/metaphlan2.py", "--version"
  end
end
