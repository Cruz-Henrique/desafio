import textwrap

def menu() :
    menu = """\n

    #########MENU#########

    [d]\t  Depósito
    [s]\t  Saque
    [e]\t  Extrato
    [nc]\t Nova Conta
    [lc]\t Lista de Contas
    [nu]\t Novo Usuário
    [q]\t  Sair

    #######################
    """ 
    return input(textwrap.dedent(menu))


def depositar(saldo, valor, extrato,/):
     
    if valor > 0:
        saldo += valor
        extrato += f'Deposito de :\tR$ {valor:.2f}\n'
        print('\n Operação realizada com sucesso!')
    else :
        print('\n Falha!Operação não pode ser realizada!')    
    return saldo,extrato 
          


def sacar(*,saldo, valor, extrato, limite, numero_de_saques, limite_saques):
    excedeu_saldo = valor > saldo
    excedeu_limite = valor > limite
    excedeu_saques = numero_de_saques >= limite_saques

    if excedeu_saldo :
        print('\nFalha na Operação! Saldo insuficiente!')

    elif excedeu_limite :
        print('\nFalha  na Operação!Excedeu Limite do Saque permitido.')

    elif excedeu_saques :
        print('\nFalha na Operação!Excedeu o limite de Saques diários.')

    elif valor > 0:
        saldo -= valor
        extrato += f'Saque :\t\tR$ {valor:.2f}\n'
        numero_de_saques +=1
        print('Saque realizado com sucesso!')

    else :
        print('\n Operação Inválida! Tente Novamente.')

    return saldo, extrato 


def exibir_extrato(saldo,/,*, extrato):
    print('\n*************Extrato*************')
    print('Não foi relaizado movimentações .'if not extrato else extrato)
    print(f'\nSaldo :\tR$ {saldo:.2f}')
    print('*********************************')        


def criar_usuario(usuarios):
    cpf = input('Digite seu CPF(Somente números, sem pontos ou traços):')
    usuario = filtrar_usuario(cpf,usuarios)

    if usuario :
        print('CPF já está cadastrado nesse banco!')

        return 
    
    nome = input('Informe seu nome completo : ')
    data_nascimento = input('Informe sua data de nascimento, no formato (dd-mm-aaaa)')
    endereco = input('Informe seu endereço(logradouro, nro - bairro - cidade/sigla do estado):')

    usuarios.append({'nome':nome,'data_nascimento':data_nascimento, 'cpf': cpf, 'endereço': endereco})

    print('\tCadastrado Realizado com Sucesso!')
    print('\tBem-vindo ao banco Banks')

         



def filtrar_usuario(cpf,usuarios):
    usuarios_filtrados = [usuario for usuario in usuarios if usuario["cpf"] == cpf ]
    return usuarios_filtrados[0] if usuarios_filtrados else None


def criar_conta(agencia, numero_conta, usuarios):
    cpf = input('Informe seu CPF (Somente números!) :')
    usuario =  filtrar_usuario(cpf,usuarios)
    
    if usuario:
        print('\nConta criada com sucesso!')
        return {'agencia':agencia,'numero_conta':numero_conta, 'usuario':usuario}
    
    print('Usuário não encotrado!Fluxo de criação de conta encerrado!')


def listar_contas(contas):
    for conta in contas :
        linha = f"""\t 
            Agência :\t{conta['agencia']}
            C/C:\t\t{conta['numero_conta']}
            Titular:\t{conta['usuario']['nome']}
        """
        print('='*100)
        print(textwrap.dedent(linha))


def main():
    LIMITE_SAQUES = 3
    AGENCIA = '0001'

    saldo =0
    limite = 500
    extrato = ''
    numero_de_saques = 0
    usuarios = []
    contas = []

    while True :
        opcao = menu()

        if opcao == 'd':
             
            valor = float(input("Informe valor do depósito: ")) 

            saldo,extrato = depositar(saldo,valor,extrato)

        elif opcao == 's':

            valor =float(input('Informe o valor que deseja sacar: '))
                 
            saldo, extrato = sacar(
                saldo = saldo,
                valor = valor,
                extrato = extrato,
                limite = limite,
                numero_de_saques = numero_de_saques,
                limite_saques = LIMITE_SAQUES,
            )
                 
        elif opcao == 'e':
            exibir_extrato(saldo, extrato = extrato)


        elif opcao == 'nu':   

            criar_usuario(usuarios)

        elif opcao == 'nc' :
            numero_conta = len(contas) + 1
            conta = criar_conta(AGENCIA,numero_conta,usuarios)

            if conta :
                contas.append(conta)
          
        elif opcao == 'lc':
               listar_contas(contas)

        elif opcao == 'q':
            break
        else: 
            print('Operação Inválida. Tente Novamente!')  

main()
