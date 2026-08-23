add_cus_dep('svg', 'pdf_tex', 0, 'inkscape_to_pdftex');

sub inkscape_to_pdftex {
    system("inkscape --export-filename=\"$_[0].pdf\" --export-latex \"$_[0].svg\"");
}
