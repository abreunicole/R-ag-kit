# Instalar os pacotes necessários para o desenvolvimento do kit
install.packages(c("usethis", "devtools", "ellmer"))

# Cria a estrutura formal do pacote R na pasta atual
usethis::create_package(".", open = FALSE)
