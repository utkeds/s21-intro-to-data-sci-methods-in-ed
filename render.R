rmarkdown::render_site()
fs::dir_copy("_site", "docs")
fs::dir_delete("_site")