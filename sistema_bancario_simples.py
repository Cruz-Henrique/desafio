menu = '''

[d] Depositar
[s] Sacar
[e] Extrato
[q] Sair

'''

saldo = 0
limite = 500
extrato = ''
numero_de_saques = 0
LIMITE_SAQUE = 3

while True :

    opcao = input(menu)
   
   

    if opcao == 'd':
        print('Depósito')
        #aqui começo fazer resolução depósito:
        valor = float(input('Informe o valor do depósito:'))
        if valor > 0 :
            saldo += valor
            extrato += f'Depósito: R$ {valor:.2f}\n'
        else :
            print('Depósito de valor inválido!Atenção!')
           
    elif opcao == 's':
        print('Saque')
        valor = float(input('Informe valor do seu saque: '))
        
        excedeu_saldo = valor > saldo

        excedeu_limite = valor > saldo

        excedeu_saques = numero_de_saques >= LIMITE_SAQUE
        
        if excedeu_saldo:
            print('Falha na Operação. Por falta de Saldo!')

        elif excedeu_limite:
            print('Falha na Operação! Limite insuficiente!')    

        elif excedeu_saques:
            print('Número de saques excedido! Falha na Operação!') 

        elif valor > 0:
            saldo -= valor
            extrato += f'Saque: R$ {valor:.2f}\n' 
            numero_de_saques +=1   

        else: 
            print('Valor de saque inválido! Informe outro valor ou verifique seu saldo.')    
        
    elif opcao == 'e':
        print('\n*************Extrato*************')
        print('Não foi relaizado movimentações .'if not extrato else extrato)
        print(f'\nSaldo : R$ {saldo:.2f}')
        print('*********************************')        

    elif opcao == 'q':
        break

    else :
        print('Operação inválida, por favor informa novamente a operação desejada.')

