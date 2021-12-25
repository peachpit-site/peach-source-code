Balabolka (aplikacja konsolowa), wersja 1.78
Copyright (c) 2013-2021 Ilya Morozov
Wszystkie prawa zastrze�one

WWW: http://balabolka.site/pl/bconsole.htm
E-mail: crossa@list.ru

Licenzja: Freeware
System operacyjny: Microsoft Windows XP/Vista/7/8/10
Microsoft Speech API: 4.0/5.0
Microsoft Speech Platform: 11.0



*** Wiersz polece� ***

balcon [parametry ...]


*** Parametry wiersza polece� ***

-l
   Pokaza� list� g�os�w zainstalowanych na komputerze.

-g
   Pokaza� list� dost�pnych urz�dze� audio.

-f <nazwa_pliku>
   Otworzy� plik tekstowy. Wiersz polece� mo�e zawiera� kilka parametr�w [-f].

-fl <nazwa_pliku>
   Sets the name of the text file with the list of input files (one file name per line). Wiersz polece� mo�e zawiera� kilka parametr�w [-fl].

-w <nazwa_pliku>
   Zapisa� plik d�wi�kowy w formacie WAV. Je�li parametr jest ustawiony, plik d�wi�kowy zostanie utworzony. Je�li parametr nie jest ustawiony, tekst zostanie przeczytany na g�os.

-n <nazwa_g�osu>
   Wybra� g�os (wystarczy poda� cz�� jego nazwy). Je�li parametr nie jest ustawiony, b�dzie u�ywany g�os wybrany w Panelu sterowania systemu Windows.

-id <liczba>
   Wybra� g�os komputerowy za pomoc� identyfikatora j�zyka (Locale ID). Takie identyfikatory s� przypisane wszystkim j�zykom przez programist�w Microsoft
   (np. "1045" lub "0x0415" - j�zyk polski, "1058" lub "0x0422" - j�zyk ukrai�ski).
   Program wybierze z listy pierwszy g�os, identyfikator kt�rego odpowiada okre�lonej warto�ci.
   Je�li ten parametr nie zostanie okre�lony, b�dzie u�ywany g�os okre�lony przez parametr [-n] lub wybrany w Panelu sterowania systemu Windows.
   Lista identyfikator�w: https://msdn.microsoft.com/en-us/library/cc233982.aspx

-m
   Pokaza� parametry wybranego g�osu.

-b <liczba>
   Wybra� urz�dzenie audio przez jego numer na li�cie dost�pnych urz�dze� do odtwarzania d�wi�ku. Numer urz�dzenia domy�lnego dor�wna 0.

-r <tekst>
   Sets the audio output device by its name.

-c
   U�y� tekstu ze schowka.

-t <tekst>
   U�y� tekstu z wiersza polece�. Wiersz polece� mo�e zawiera� kilka parametr�w [-t].

-i
   U�y� tekstu z standarowego strumienia wej�cia (STDIN).

-o
   SAPI 4: parametr nie jest u�ywany.
   SAPI 5 i Microsoft Speech Platform: zapisa� d�wi�k do standarowego strumienia wyj�cia (STDOUT); je�li parametr jest ustawiony, parametr [-w] jest ignorowany.

-s <liczba>
   SAPI 4: ustawi� pr�dko�� mowy w zakresie od 0 do 100 (brak warto�ci domy�lnych).
   SAPI 5 i Microsoft Speech Platform: ustawi� pr�dko�� mowy w zakresie od -10 do 10 (warto�� domy�lna dor�wna 0).

-p <liczba>
   SAPI 4: ustawi� ton mowy w zakresie od 0 do 100 (brak warto�ci domy�lnych).
   SAPI 5 i Microsoft Speech Platform: ustawi� ton mowy w zakresie od -10 do 10 (warto�� domy�lna dor�wna 0).

-v <liczba>
   SAPI 4: parametr nie jest u�ywany.
   SAPI 5 i Microsoft Speech Platform: ustawi� g�osno�� mowy w zakresie od 0 do 100 (warto�� domy�lna dor�wna 100).

-e <liczba>
   Ustawi� d�ugo�� pauzy mi�dzy zdaniami (milisekundy). Warto�� domy�lna dor�wna 0.

-a <liczba>
   Ustawi� d�ugo�� pauzy mi�dzy akapitami (milisekundy). Warto�� domy�lna dor�wna 0.

-d <nazwa_pliku>
   U�y� s�ownika do korekty wymowy (plik z rozszerzeniem *.BXD, *.DIC lub *.REX). Wiersz polece� mo�e zawiera� kilka parametr�w [-d].

-k
   Zatrzyma� prace innych egzemplarzy aplikacji konsolowej uruchomionych na komputerze.

-ka
   Kills the active copy of the console application in the computer's memory.

-pr
   Make pause or resume reading aloud by the active copy of the application. The action is the same as for the context menu item "Pause"/"Resume".

-q
   Doda� aplikacj� do kolejki. Aplikacja konsolowa b�dzie czeka�, a� inne egzemplarzy programu sko�cz� prac�.

-lrc
   SAPI 4: parametr nie jest u�ywany.
   SAPI 5 i Microsoft Speech Platform: utworzy� plik LRC, je�li ustawione parametry [-w] lub [-o].

-srt
   SAPI 4: parametr nie jest u�ywany.
   SAPI 5 i Microsoft Speech Platform: utworzy� plik SRT, je�li ustawione parametry [-w] lub [-o].

-vs <nazwa_pliku>
   SAPI 4: parametr nie jest u�ywany.
   SAPI 5 i Microsoft Speech Platform: sets the name of output text file with visemes, if the option [-w] is specified.
   A viseme is the mouth shape that corresponds to a particular speech sound. SAPI supports the list of 21 visemes.
   This list is based on the original Disney visemes. The application will create the audio file and then read it aloud to get visemes and their timecodes.
   The list of visemes supported by SAPI 5: https://msdn.microsoft.com/en-us/library/ms720881(v=vs.85).aspx

-sub
   Tekst wygl�da jak napisy do plik�w i musi by� przekszta�cony w plik d�wi�kowy z wrachowaniem okre�lonych odst�p�w czasu.

-tray
   Pokaza� ikon� programu w obszarze powiadomie� systemu operacyjnego.
   To pozwoli u�ytkownikowi monitorowa� post�p operacji, oraz przerwa� proces klikaj�c "Stop" w menu kontekstowym.

-ln <liczba>
   Selects a line from the text file by using of a line number. The line numbering starts at "1".
   The interval of numbers can be used for selecting of more than one line (for example, "26-34").
   Wiersz polece� mo�e zawiera� kilka parametr�w [-ln].

-fr <liczba>
   SAPI 4: parametr nie jest u�ywany.
   SAPI 5 i Microsoft Speech Platform: sets the output audio sampling frequency in kHz (8, 11, 12, 16, 22, 24, 32, 44, 48).
   If the option is not specified, the default value of the selected voice will be used.

-bt <liczba>
   SAPI 4: parametr nie jest u�ywany.
   SAPI 5 i Microsoft Speech Platform: sets the output audio bit depth (8 lub 16).
   If the option is not specified, the default value of the selected voice will be used.

-ch <liczba>
   SAPI 4: parametr nie jest u�ywany.
   SAPI 5 i Microsoft Speech Platform: sets the output audio channel mode (1 lub 2).
   If the option is not specified, the default value of the selected voice will be used.

-? lub -h
   Pokaza� opis parametr�w wiersza polece�.

--encoding <kodowanie> lub -enc <kodowanie>
   Kodowanie tekstu ze standardowego strumiena wej�ciowego ("ansi", "utf8" lub "unicode"). Warto�� domy�lna dor�wna "ansi".

--silence-begin <liczba> lub -sb <liczba>
   Ustawi� d�ugo�� pauzy na pocz�tku pliku d�wi�kowego (w milisekundach). Warto�� domy�lna dor�wna 0.

--silence-end <liczba> lub -se <liczba>
   Ustawi� d�ugo�� pauzy na ko�cu pliku d�wi�kowego (w milisekundach). Warto�� domy�lna dor�wna 0.

--lrc-length <liczba>
   Ustawi� maksymaln� d�ugo�� wierszy plika LRC (symboli).

--lrc-fname <nazwa_pliku>
   Nazwa pliku LRC. Parametr mo�e by� przydatny gdy w wierszu polece� ustawiony parametr [-o].

--lrc-enc <kodowanie>
   Kodowanie pliku LRC ("ansi", "utf8" lub "unicode"). Warto�� domy�lna dor�wna "ansi".

--lrc-offset <liczba>
   Ustawi� przesuni�cie czasu dla pliku LRC (milisekundy).

--lrc-artist <tekst>
   Znacznik dla pliku LRC: wykonawca utworu.

--lrc-album <tekst>
   Znacznik dla pliku LRC: album.

--lrc-title <tekst>
   Znacznik dla pliku LRC: nazwa utworu.

--lrc-author <tekst>
   Znacznik dla pliku LRC: autor.

--lrc-creator <tekst>
   Znacznik dla pliku LRC: tw�rc� pliku.

--lrc-sent
   Inserts blank lines after sentences in the LRC file.

--lrc-para
   Inserts blank lines after paragraphs in the LRC file.

--srt-length <liczba>
   Ustawi� maksymaln� d�ugo�� wierszy plika SRT (symboli).

--srt-fname <nazwa_pliku>
   Nazwa pliku SRT. Parametr mo�e by� przydatny gdy w wierszu polece� ustawiony parametr [-o].

--srt-enc <kodowanie>
   Kodowanie pliku SRT ("ansi", "utf8" lub "unicode"). Warto�� domy�lna dor�wna "ansi".

--raw
   SAPI 4: parametr nie jest u�ywany.
   SAPI 5 i Microsoft Speech Platform: zapisa� d�wiek w formacie RAW PCM; dane nie zawieraj� tytu�u formatu WAV.
   Parametr wykorzystuj� si� razem z parametrem [-o].

--ignore-length lub -il
   SAPI 4: parametr nie jest u�ywany.
   SAPI 5 i Microsoft Speech Platform: nie zapisywa� rozmiar audio do tytu�u formatu WAV. Parametr wykorzystuj� si� razem z parametrem [-o].

--sub-format <tekst>
   Format napis�w filmowych ("srt", "lrc", "ssa", "ass", "smi" lub "vtt"). Je�li parametr nie okre�lony format zostanie wybrany przez rozszerzenie nazwy pliku napis�w.

--sub-fit lub -sf
   SAPI 4: parametr nie jest u�ywany.
   SAPI 5 i Microsoft Speech Platform: automatycznie zwi�ksza� pr�dko�� mowy aby zmie�ci� si� w odst�py czasu okre�lone w napisach.

--sub-max <liczba> lub -sm <liczba>
   SAPI 4: parametr nie jest u�ywany.
   SAPI 5 i Microsoft Speech Platform: ustawi� maksymaln� pr�dko�� mowy w zakresie od -10 do 10 (do konwersji napis�w w pliki d�wi�kowe).

--delete-file lub -df
   Usun�� plik tekstowy po zako�czeniu czytania na g�os lub zapisywania pliku d�wi�kowego.

--ignore-square-brackets lub -isb
   Ignore text in [square brackets].

--ignore-curly-brackets lub -icb
   Ignore text in {curly brackets}.

--ignore-angle-brackets lub -iab
   Ignore text in <angle brackets>.

--ignore-round-brackets lub -irb
   Ignore text in (round brackets).

--ignore-url lub -iu
   Ignore URLs.

--ignore-comments lub -ic
   Ignore comments in text. Single-line comments start with // and continue until the end of the line. Multiline comments start with /* and end with */.

--voice1-name <nazwa_g�osu>
   SAPI 4: parametr nie jest u�ywany.
   SAPI 5 i Microsoft Speech Platform: sets the additional voice name to read foreign words in text (the part of the name will be enough).
   The option is used together with the option [--voice1-langid]. Other voices can be set by options [--voice2-name], [--voice3-name], etc.

--voice1-langid <identyfikator_j�zyka>
   Sets the language ID for foreign words in text. The option is used together with the option [--voice1-name]. The command line may contain more than one option [--voice1-langid]. Also an option may contain a comma-separated list of IDs.
   The list of supported language IDs is based on ISO 639-1 codes: am, ar, az, ba, bg, be, ca, cs, cu, cv, da, de, el, en, es, et, eu, fi, fil, fr, ja, he, hi, hr, hu, hy, it, gn, gu, ka, kk-Cyr, kk-Lat, kn, ko, ky, lo, lt, lv, mk, no, pl, pt, ro, ru, sk, sl, sr-Cyr, sr-Lat, sv, tg, th, tr, tt, uk, zh.

--voice1-rate <liczba>
   Sets the rate for the additional voice in a range of -10 to 10 (the default is 0).

--voice1-pitch <liczba>
   Sets the pitch for the additional voice in a range of -10 to 10 (the default is 0).

--voice1-volume <liczba>
   Sets the volume for the additional voice in a range of 0 to 100 (the default is 100).

--voice1-roman
   Use the default voice to read Roman numerals in text. If text with non-Latin characters contains Roman numerals, the application will not change a voice to read them.

--voice1-digit
   Use the default voice to read numbers in text.

--voice1-length <liczba>
   Set the minimal length of foreign text parts that will be read by the additional voice (in characters).


*** Przyk�ady ***

balcon -l

balcon -n "Microsoft Anna" -m

balcon -f "d:\Text\book.txt" -w "d:\Sound\book.wav" -n "Emma"

balcon -n "Callie" -c -d "d:\rex\rules.rex" -d "d:\dic\rules.dic"

balcon -n "Ewa" -t "Tekst b�dzie czytany wolno." -s -5 -v 70

balcon -k

balcon -f "d:\Text\book.txt" -w "d:\Sound\book.wav" -lrc --lrc-length 80 --lrc-title "The Lord of the Rings"

balcon -f "d:\Text\film.srt" -w "d:\Sound\film.wav" -n "Laura" --sub-fit --sub-max 2

balcon -f "d:\Text\book.txt" -n Kimberly --voice1-name Tatyana --voice1-langid ru


Przyk�ad wykorzystania aplikacji razem z oprogramowaniem narz�dziowym LAME.EXE:

balcon -f d:\book.txt -n Heather -o --raw | lame -r -s 22.05 -m m -h - d:\book.mp3


Przyk�ad wykorzystania aplikacji razem z oprogramowaniem narz�dziowym OGGENC2.EXE:

balcon -f d:\book.txt -n Heather -o -il | oggenc2 --ignorelength - -o d:\book.ogg


Przyk�ad wykorzystania aplikacji razem z oprogramowaniem narz�dziowym WMAENCODE.EXE:

balcon -f d:\book.txt -n Heather -o -il | wmaencode - d:\book.wma --ignorelength


*** Plik konfiguracyjny ***

Parametry mo�na zachowa� jak plik konfiguracyjny "balcon.cfg" w tym samym folderze co aplikacja konsolowa.

Przyk�ad zawarto�ci pliku:
===============
-f d:\Text\book.txt
-w d:\Sound\book.wav
-n Microsoft Anna
-s 2
-p -1
-v 95
-e 300
-d d:\Dict\rules.bxd
-lrc
--lrc-length 75
--lrc-enc utf8
--lrc-offset 300
===============

Program mo�e kombinowa� parametry z pliku konfiguracyjnego i wiersza polece�.


*** Audio Clips ***

The application allows to insert links to external WAV files (audio clips) into text. Audio clip tag will look like:

{{Audio=C:\Sounds\ring.wav}}

When speaking text aloud, the program will pause when the audio clip tag is reached, play the audio clip and resume speaking.
When converting to audio files, the audio clip will be embedded in the audio file created by the application.


*** "Voice" Tag ***

If it is necessary to change a voice or its properties during reading aloud, a special tag can be used for SAPI 5 and Microsoft Speech Platform (SAPI 4 voices will ignore this tag).

The tag format:

{{Voice=Name;Rate;Pitch;Volume}}

- Name: the name of a voice (one word or the part of a word is enough);
- Rate: the rate of a voice (values range from -10 to 10);
- Pitch: the pitch of a voice (values range from -10 to 10);
- Volume: the volume (values range from 0 to 100).

A tag applies to all subsequent text. The values are separated by semicolons. For example:

This text will be spoken by the default voice of Balabolka. {{Voice=Kimberly;0;0;100}} The voice 'Kimberly' will read the other text.

The tag's content is case insensitive. Values for some properties can be omitted:

{{voice=eric;;;50}}

{{Voice=Hans;-1}}

{{Voice=Rachel}}

To return to the default voice, use this tag:

{{Voice=}}

Warning! It is impossible to switch between SAPI 5 voices and voices of the Microsoft Speech Platform.


*** "Pause" Tag ***

A specified number of milliseconds of silence can be inserted into the output audio file. For example:

One hundred twenty milliseconds of silence {{Pause=120}} just occurred.


*** Licencja ***

Prawo do u�ytku niekomercyjnego: 
- dla os�b fizycznych - bez ogranicze�;
- dla os�b prawnych - z zastrze�eniem ogranicze�, co okre�la "Umowa licencyjna" programu Balabolka.

U�ytek komercyjny dozwolony jedynie za wcze�niejsz� zgod� posiadacza praw autorskich.

###