# Defina o caminho do arquivo de entrada e saída
# Crie o arquivo logins.txt insira os logins
$entrada = "C:\suapastaatual\logins.txt"
$saida = "C:\suapastaatual\arquivo_saida.csv"

# Crie o arquivo de saída se ele não existir
if (-Not (Test-Path -Path $saida)) {
    New-Item -Path $saida -ItemType File
}

# Certifique-se de que o arquivo de saída seja limpo
Clear-Content -Path $saida

# Leia os logins do arquivo de entrada
$logins = Get-Content -Path $entrada

# Para cada login, busque o nome completo no Active Directory
foreach ($login in $logins) {
    # Tente buscar o nome completo do usuário no AD
    try {
        $usuario = Get-ADUser -Identity $login -Properties DisplayName -ErrorAction Stop

        # Se o usuário for encontrado, adicione o login e nome completo separados por vírgula
        if ($usuario) {
            $nomeCompleto = $usuario.DisplayName
            # Escreva no arquivo de saída: login e nome completo separados por vírgula
            "$login,$nomeCompleto" | Out-File -FilePath $saida -Append
        }
    } catch {
        # Caso o login não seja encontrado, escreva o login e 'NÃO ENCONTRADO' no arquivo
        "$login,NÃO ENCONTRADO" | Out-File -FilePath $saida -Append
    }
}

Write-Host "Processo concluído. Resultado salvo em: $saida"
