

import os

# My whitespace rules: spaces before and after :=, =, <, >, <>, +, and -.
# Spaces after but not before , and :

def rewhitespace(s):
    s = s.replace('=',' = ')
    s = s.replace('  =',' =')
    s = s.replace('=  ','= ')
    s = s.replace(': =',':=')
    s = s.replace(':',': ')
    s = s.replace(':  ',': ')
    s = s.replace(': =',':=')
    s = s.replace(' :', ':')
    s = s.replace(': =',': =')
    s = s.replace(':=', ' :=')
    s = s.replace('+',' + ')
    s = s.replace('  +',' +')
    s = s.replace('+  ','+ ')
    s = s.replace('-',' - ')
    s = s.replace('  -',' -')
    s = s.replace('-  ','- ')
    s = s.replace('<',' < ')
    s = s.replace('  <',' <')
    s = s.replace('<  ','< ')
    s = s.replace('>',' > ')
    s = s.replace('  >',' >')
    s = s.replace('>  ','> ')
    s = s.replace('< >','<>')
    s = s.replace('< =','<=')
    s = s.replace('> =','>=')
    s = s.replace(' ,', ',')
    s = s.replace(',',', ')
    s = s.replace(',  ',', ')
    return s;

# The dictionary for changing the names of functions and variables, e.g.
# if you want to change qp to QuantityOfPorcupines you would add
# 'qp' : 'QuantityOfPorcupines' to the dictionary.

tdic = {
    'safeHighlight' : 'Highlight',
    'pStart' : 'ParagraphStart'
       }

tokens = []
files = os.listdir(os.curdir)
for filename in files:
    if filename[-4:] == '.pas':    # Cos I'm looking for Pascal files.
        print(filename)
        text_file = open(filename, "r", encoding = "utf8")
        data = text_file.read()
        text_file.close()
        output = ''
        i = 0
        mode = 'plain'
        # By 'plain' I mean not in comments or quotes.
        while i < len(data):
            new_mode = 'plain'
            if mode == 'plain':
                # ... then we look for the start of non-plain text.
                min_c1 = data.find('{',i) # The start of a multiline comment.
                if min_c1 == -1:
                    min_c1 = len(data)
                min_c2 = data.find('//',i) # The start of a single-line comment
                if min_c2 == -1:
                    min_c2 = len(data)
                min_qu = data.find('\'',i) # The start of a string literal
                if min_qu == -1:
                    min_qu = len(data)
                min_al = min([min_c1, min_c2, min_qu])
                new_i = min_al
                if min_al == len(data):
                    pass
                elif min_al == min_c1:
                    new_mode = 'multiline_comment'
                elif min_al == min_c2:
                    new_mode = 'single_line_comment'
                elif min_al == min_qu:
                    new_mode = 'string_literal'
            elif mode == 'multiline_comment':
                new_i = data.find('}',i+1) + 1
            elif mode == 'single_line_comment':
                new_i = data.find('\n',i+1) + 1
            elif mode == 'string_literal':
                new_i = data.find('\'',i+1) + 1
                        
            if mode == 'plain':
                respaced = rewhitespace(data[i:new_i])

                # We tokenize the plain text.
              
                
                tkn = False
                retokened = ''
                for j in range(len(respaced)+1):
                    if tkn:
                        if j == len(respaced) or not (respaced[j].isalnum() or respaced[j] == '_'):
                            token = respaced[tknstart:j]
                            cf = token.casefold()
                            if cf in tdic.keys():
                                token = tdic[cf]
                            
                            if not token in tokens:
                                tokens.append(token)
                            retokened = retokened + token
                            tkn = False
                            if j != len(respaced):
                                retokened = retokened + respaced[j]
                    else:
                        if j == len(respaced):
                            break
                        if respaced[j].isalpha() or respaced[j] == '_':
                            tknstart = j    
                            tkn = True
                        else:
                            retokened = retokened + respaced[j]
                    

                output = output + retokened
            else: # Else we're in a comment or a string literal and mustn't process it.
                output = output + data[i:new_i]

            i = new_i
            mode = new_mode

        text_file = open(filename, "w", encoding = "utf8")
        text_file.write(output)
        text_file.close()

# Finally we print out the list of variable/function names (and of course the keywords of the language
# like if and else, unless you filter them out.)

tokens.sort()

ignore = ['a', 'akTop', 'akBottom', 'akLeft', 'akRight', 'and', 'array', 'as',
          'bdLeftToRight', 'bdRightToLeft', 'begin', 'byte', 'break', 'boolean',
          'c', 'case', 'char', 'clBlack', 'clBlue', 'clBool',
          'clDefault', 'clEntry', 'clFixed', 'clGreen', 'clKBody', 'clKeys',
          'clPara', 'clPlain', 'clPrompt', 'clQBody', 'clQForms', 'clRed',
          'clTitle', 'clVocab', 'class', 'constructor','crArrow', 'crDefault', 'crHourglass',
          'div', 'double',
          'else', 'end', 'except', 'emNormal', 'emPassword',
          'false', 'fsBold', 'fsItalic', 
          'finally', 'fmOpenRead', 'f', 'for' 'forward', 'function',
          'fsBold', 'fsItalic', 
          'g',
          'i', 'if', 'in', 'initialization',
          'inherited', 'interface', 'integer',
          'j',
          'k',
          'mrAbort', 'mrCancel', 'mrClose',
          'mtCustom', 'mrOK', 'mrYes',
          'paCenter', 'paJustify', 'private', 'public', 'procedure', 'protected',
          'psKBody', 'psKeys', 'psPadding',
          'psPara', 'psPlain', 'psPrompt', 'psQBody', 'psQForms', 'psSetting',
          'psSettingsHeader', 'psTitle', 'psTopic', 'psVocab', 'psBool', 'psEntry', 'psFixed', 'psPicture',
          'record',
          's', 'ssAlt', 'ssShift', 'ssCtrl',
          'then', 'to', 'true', 'try',
          'until', 'uses', 'unit',
          'var', 'vResHandle',
          'while', 'widestring', 'with', 'word']

filtered_list = filter(lambda t: not t in ignore, tokens)

#for t in filtered_list:
#    print('    \''+t.casefold()+'\' : \''+t[0].capitalize()+t[1:]+'\',')
