#!/bin/bash
# cria o arquivo de contatos se não houver
arquivo=$(ls | grep contatos.txt)

if [ ! $arquivo ]
then
    touch contatos.txt

    printf "Não se preocupe, criamos a agenda para você!\n\n"
fi

titulo="----- Agenda Legal! -----"
prompt="Escolha uma opção numérica: "
options=("Listar" "Procurar" "Adicionar" "Remover" "Editar")

echo "$titulo"
PS3="$prompt"
select opt in "${options[@]}" "Sair"; 
do 

    case "$REPLY" in
        1)
            contatos=$(cat contatos.txt)
            
            if [ "$contatos" ]
            then
                printf "\n$contatos\n\n"   
            else
                printf "\nSem contatos :(\n\n"
            fi
           
            ;;
        2 )
            printf "Buscar por: "
            read buscarPor 
            contato=$(cat contatos.txt | grep $buscarPor)

            if [ "$contato" ]
            then
                printf "\n$contato\n\n"   
            else
                printf "\nContato não encontrado.\n\n"
            fi
            
            ;;
        3 ) 
            printf "Nome: "
            read nome
            printf "Sobrenome: "
            read sobrenome
            printf "Numero: "
            read numero
            printf "Email: "
            read email
            
            contato=$(cat contatos.txt | grep $email)

            if [ "$contato" ]
            then
                printf "\nJá existe um contato com esse email.\n\n"
            else
                echo "$nome:$sobrenome:$numero:$email" >> contatos.txt

                printf "\nContato adicionado com sucesso!\n\n"
            fi
            
            ;;
        4 ) 
            printf "Email do contato: "
            read email

            contato=$(cat contatos.txt | grep $email)

            if [ "$contato" ]
            then
                sed -i "/$email/d" contatos.txt

                printf "\nContato removido com sucesso!\n\n"
            else
                printf "\nContato não encontrado.\n\n"
            fi

            ;;
        5 ) 
            printf "Email do contato: "
            read email

            contato=$(cat contatos.txt | grep :$email$)
            
            if [ "$contato" ] 
            then
                nome="$(cut -d':' -f1 <<< $contato)"
                sobrenome="$(cut -d':' -f2 <<< $contato)"
                numero="$(cut -d':' -f3 <<< $contato)"
                email="$(cut -d':' -f4 <<< $contato)"

                read -e -p "Nome: " -i "$nome" novoNome
                read -e -p "Sobrenome: " -i "$sobrenome" novoSobrenome
                read -e -p "Número: " -i "$numero" novoNumero
                read -e -p "Email: " -i "$email" novoEmail
                
                #verifica se o novoEmail já existe
                contato=$(cat contatos.txt | grep -c $novoEmail)

                if [ "$contato" = "1" ] && [ "$email" != "$novaEmail" ]
                then
                    printf "\nJá existe um contato com esse email.\n\n"
                else
                    linhaAntiga="$nome:$sobrenome:$numero:$email"
                    novaLinha="$novoNome:$novoSobrenome:$novoNumero:$novoEmail"
                    
                    sed -i "s/$linhaAntiga/$novaLinha/g" contatos.txt

                    printf "\nContato editado! GGEZ\n\n"
                fi                
            else
                printf "\nContato não encontrado.\n\n" 
            fi
            ;;     
        6 )
            echo "Até mais!"
            break;;
        * )
            echo "Opção inválida. Tente novamente."
            ;;
    esac
done