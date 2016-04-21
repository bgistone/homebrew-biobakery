# homebrew-biobakery
Biobakery formulae for the Homebrew package manager.

To get started, install [HomeBrew](http://brew.sh/) for MacOS or [LinuxBrew](http://linuxbrew.sh/) for Linux platforms. 

1. Tap the biobakery homebrew repository
    * `` $ brew tap biobakery/biobakery ``
2. Install the biobakery tools
    1. HUMAnN2
        * `` $ brew install humann2 ``
        * Demo databases are included with the install. To install the full databases, see the humann2 documentation: http://huttenhower.sph.harvard.edu/humann2
    2. KneadData
        * `` $ brew install kneaddata ``
        * Demo databases are included with the install. To install the full databases, see the kneaddata documentation: http://huttenhower.sph.harvard.edu/kneaddata
    3. Picrust
        * `` $ brew install picrust ``
    4. MaAsLin
        * `` $ brew install maaslin ``
    5. MetaPhlAn2
        * `` $ brew install metaphlan2 ``
    6. ShortBRED
        * Install [USEARCH](http://www.drive5.com/usearch/)
        * `` $ brew install shortbred ``
        * To install without blast (which can cause errors with g++ 5x), add the option "--without-blast"
    7. SparseDOSSA
        * `` $ brew install sparsedossa ``
    8. PPANINI
        * `` $ brew install ppanini ``
    9. LEfSe
        * `` $ brew install lefse ``
    10. GraPhlAn
        * `` $ brew install graphlan ``
    11. MicroPITA
        * `` $ brew install micropita ``
    12. BreadCrumbs
        * `` $ brew install breadcrumbs ``
    13. StrainPhlAn
        * Install [Samtools v1.19](https://sourceforge.net/projects/samtools/files/samtools/0.1.19/)
        * `` $ brew install strainphlan ``
        * To install without blast (which can cause errors with g++ 5x), add the option "--without-blast"

