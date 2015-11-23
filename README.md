# pinout-generator
Generates pinout descriptions in HTML + CSS

A simple shell script to generate standard descriptions of pin connections between 2 devices.

Sample output:

<img width="624" height="649" src="http://static.efetividade.net/img/captura-de-tela-2015-11-23-as-13.06.44-50218.png">

The corresponding input:

<img width="735" height="787" src="http://static.efetividade.net/img/captura-de-tela-2015-11-23-as-13.06.53-28976.png">

The input file is a series of lines with 3 fields (device 1 pin, device 2 pin and notes), separated by semicolons. 

When the first field on a line is empty, the script assumes that the pin on device 2 is connected to the same pin on device 1 that was referenced on the previous line, and spans cells accordingly. See what happened on pins GND and 5V on the examples above.

The output is an HTML file with an embedded CSS sheet, that can be pasted wherever you want it.
