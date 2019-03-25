;Forms for ISN AutoIt Studio

;---------- ISN Settings ----------
#include "..\Forms\ISN_Programmeinstellungen.isf" ;Hauptfenster für Programmeinstellungen
#include "..\Forms\ISN_Programmeinstellungen_Allgemein.isf" ;General Page
#include "..\Forms\ISN_Programmeinstellungen_Skripteditor.isf" ;Script Editor Page
#include "..\Forms\ISN_Programmeinstellungen_Updates.isf" ;Updates Page
#include "..\Forms\ISN_Programmeinstellungen_Skriptbaum.isf" ;Scripttree Page
#include "..\Forms\ISN_Programmeinstellungen_Darstellung.isf" ;Display Page
#include "..\Forms\ISN_Programmeinstellungen_Farbeinstellungen.isf" ;Colors Page
#include "..\Forms\ISN_Programmeinstellungen_Hotkeys.isf" ;Hotkeys Page
#include "..\Forms\ISN_Programmeinstellungen_Sprache.isf" ;Languages Page
#include "..\Forms\ISN_Programmeinstellungen_AutoBackup.isf" ;Auto Backup Page
#include "..\Forms\ISN_Programmeinstellungen_Programmpfade.isf" ;Program Paths Page
#include "..\Forms\ISN_Programmeinstellungen_Skins.isf" ;Skin Page
#include "..\Forms\ISN_Programmeinstellungen_Plugins.isf" ;Plugins Page
#include "..\Forms\ISN_Programmeinstellungen_Erweitert.isf" ;General -> Advanced Page
#include "..\Forms\ISN_Programmeinstellungen_Trophys.isf" ;Trophies Page
#include "..\Forms\ISN_Programmeinstellungen_Toolbar.isf" ;Toolbar Page
#include "..\Forms\ISN_Programmeinstellungen_Tidy.isf" ;Tidy Page
#include "..\Forms\ISN_Programmeinstellungen_Includes.isf" ;Includes Page
#include "..\Forms\ISN_Programmeinstellungen_AutoSpeicherung.isf" ;AutoSaving Page
#include "..\Forms\ISN_Programmeinstellungen_Dateitypen.isf" ;Script Editor FileTypes Page
#include "..\Forms\ISN_Programmeinstellungen_APIs.isf" ;APIs Page
#include "..\Forms\ISN_Programmeinstellungen_Makrosicherheit.isf" ;Macro Security Page
#include "..\Forms\ISN_Programmeinstellungen_Autoitpfade.isf" ;AutoIt Paths Page
#include "..\Forms\ISN_Programmeinstellungen_Tools.isf" ;Tools Page
#include "..\Forms\ISN_Programmeinstellungen_Monitor_und_Fenster.isf" ;Monitor and Windows Page
#include "..\Forms\ISN_Programmeinstellungen_QuickView.isf" ;QuickView Page
;-----------------------------------------


;----------Projekteinstellungen----------
#include "..\Forms\ISN_Projekteinstellungen.isf"

;Default Page für Projekteinstellungen
GUICtrlSetState($projekteinstellungen_dummytab, $GUI_HIDE) ;Dummytab verstecken
GUICtrlSetState($Projekteinstellungen_eigenschaften_tab, $GUI_SHOW)
_GUICtrlTreeView_SelectItem ($projekteinstellungen_navigation,$projekteinstellungen_navigation_Eigenschaften)
_GUICtrlTreeView_Expand ($projekteinstellungen_navigation,$projekteinstellungen_kompilierungseinstellungen)
GUICtrlSetState($projekteinstellungen_dummytab,$GUI_HIDE)
;----------------------------------------



#include "..\Forms\ISN_Programmeinstellungen_Debug.isf" ;Makro Skript starten
#include "..\Forms\ISN_Programmeinstellungen_Programmpfade_Weitere_Projektpfade.isf"
#include "..\Forms\ISN_QuickView.isf" ;QuickView GUI
#include "..\Forms\ISN_Warte_auf_Aktion.isf" ;Warte auf Aktion (beim Start oder Beenden des ISNs)
#include "..\Forms\ISN_Datei_waehlen.isf" ;Choose File GUI
#include "..\Forms\ISN_Funktionsliste.isf" ;Func. List GUI
#include "..\Forms\ISN_Warnung.isf" ;Warnungen GUI
#include "..\Forms\ISN_Willkommen.isf" ;Willkommen GUI
#include "..\Forms\ISN_Neues_Projekt.isf" ;Neues Projekt
#include "..\Forms\ISN_Ladefenster.isf" ;Loading GUI
#include "..\Forms\ISN_Suchen_und_ersetzen.isf" ;Suchen und ersetzen
#include "..\Forms\ISN_Weitere_Dateien_Kompilieren.isf" ;Weitere Dateien Kompilieren
#include "..\Forms\ISN_Icon_auswahl.isf" ;Icon auswählen
#include "..\Forms\ISN_Ueber.isf" ;Über das ISN Fenster
#include "..\Forms\ISN_Startparameter.isf" ;Startparameter
#include "..\Forms\ISN_Neue_Datei_erstellen.isf" ;Neue Datei erstellen
#include "..\Forms\ISN_Projekt_wird_Kompiliert.isf" ;Projekt wird kompiliert
#include "..\Forms\ISN_Parameter_Editor.isf" ;Parameter Editor
#include "..\Forms\ISN_Makro_auswaehlen.isf" ;Marko auswählen GUI
#include "..\Forms\ISN_Makros.isf" ;Markoeditor
#include "..\Forms\ISN_Konfiguration_exportiern.isf" ;Konfiguration Exportieren
#include "..\Forms\ISN_Neues_Makro.isf" ;Neues Makro
#include "..\Forms\ISN_Zu_Zeile_Springen.isf" ;Springe zu Zeile
#include "..\Forms\ISN_Makro_Trigger_auswaehlen.isf" ;Makro Trigger wählen
#include "..\Forms\ISN_Makro_Aktion_auswaehlen.isf" ;Makro Aktion wählen
#include "..\Forms\ISN_Makro_Statusbar.isf" ;Makro Statusbar
#include "..\Forms\ISN_In_Ordner_nach_Text_Suchen.isf" ;Text in ordnern suchen
#include "..\Forms\ISN_In_Ordner_nach_Text_Suchen_Suche_laeuft.isf" ;Text in ordnern suchen (Suche läuft gui)
#include "..\Forms\ISN_Makro_Sleep.isf" ;Makro Sleep
#include "..\Forms\ISN_Makro_Execute.isf" ;Makro Execute
#include "..\Forms\ISN_Makro_Dateioperation.isf" ;Makro Dateioperation
#include "..\Forms\ISN_Makro_Weitere_Pfade.isf" ;Weitere Pfade
#include "..\Forms\ISN_Makro_Datei_ausfuehren.isf" ;Makro Datei ausführen
#include "..\Forms\ISN_Makro_Kompilieren.isf" ;Makro Kompilieren
#include "..\Forms\ISN_Makro_wird_kompiliert.isf" ;Makro wird Kompilieren
#include "..\Forms\ISN_Makro_Makroslot_Icon.isf" ;Makroslot Icon
#include "..\Forms\ISN_MsgBox_Generator.isf" ;MsgBox generator
#include "..\Forms\ISN_Makro_MsgBox_Generator.isf" ;Makro MsgBox generator
#include "..\Forms\ISN_Makro_Parameter.isf" ;Makro Parametereinstellungen
#include "..\Forms\ISN_Makro_Logeintrag_hinzufuegen.isf" ;Makro Logeintrag hinzufügen
#include "..\Forms\ISN_Trophaeen.isf" ;Trophäen
#include "..\Forms\ISN_Farbtoolbox.isf" ;Farbtoolbox
#include "..\Forms\ISN_Detailinfos_zu_aktuellem_Wort.isf" ;Info zu akteullem Wort (Farbwert)
#include "..\Forms\ISN_Mini_Farbpicker.isf" ;Mini Farbpicker
#include "..\Forms\ISN_Einstellungen_werden_gespeichert.isf" ;Einstellungen werden gespeichert
#include "..\Forms\ISN_Hotkey_bearbeiten.isf" ;Hotkey Bearbeiten
#include "..\Forms\ISN_Hotkey_Warte_auf_Tastendruck.isf" ;Hotkey Warte auf Tastendruck
#include "..\Forms\ISN_Projektverwaltung.isf" ;Projektverwaltung
#include "..\Forms\ISN_Codeausschnitt.isf" ;Codeausschnitt GUI
#include "..\Forms\ISN_Warte_auf_Wrapper.isf" ;Warte auf Wrapper
#include "..\Forms\ISN_Warte_auf_Makro.isf" ;Warte auf Makro
#include "..\Forms\ISN_Projektverwaltung_Neue_Vorlage.isf" ;Neue Vorlage
#include "..\Forms\ISN_Bitwise_Operations_GUI.isf" ;Bitwise Operations GUI
#include "..\Forms\ISN_Datei_loeschen.isf" ;Datei löschen
#include "..\Forms\ISN_Aenderungsprotokolle_Neuer_Eintrag.isf" ;Changelog neuer Eintrag
#include "..\Forms\ISN_Makro_Version_Aendern.isf" ;Makro Projektversion ändern
#include "..\Forms\ISN_Makro_Skript_starten.isf" ;Makro Skript starten
#include "..\Forms\ISN_Aenderungsprotokolle.isf" ;Änderungsprotokolle Manager
#include "..\Forms\ISN_Aenderungsprotokolle_Bericht.isf" ;Änderungsprotokolle Bericht generieren
#include "..\Forms\ISN_Aenderungsprotokolle_Bericht_Hilfe.isf" ;Änderungsprotokolle Bericht Hilfe
#include "..\Forms\ISN_Skriptbaum_Filter.isf" ;Skriptbaum Filter
#include "..\Forms\ISN_Makro_Codeausschnitt.isf" ;Makro Codeausschnitt
#include "..\Forms\ISN_Warte_auf_Plugin.isf" ;Warte auf Plugin
#include "..\Forms\ISN_PELock_Obfuscator.isf" ;PELock Obfuscator
#include "..\Forms\ISN_PELock_Obfuscator_laeuft.isf" ;PELock Obfuscator Vorgang läuft
#include "..\Forms\ISN_ToDoListe_Manager.isf" ;ToDo Liste Manager
#include "..\Forms\ISN_ToDoListe_Kategorien_verwalten.isf" ;Kategorien der ToDo Liste verwalten
#include "..\Forms\ISN_ToDoListe_Neue_Kategorie.isf" ;Neue Kategorie erstellen/bearbeiten
#include "..\Forms\ISN_ToDoListe_Kategorie_loeschen.isf" ;Kategorie löschen
#include "..\Forms\ISN_ToDoListe_Neuer_Eintrag.isf" ;Neue Aufgabe erstellen
#include "..\Forms\ISN_Bitte_Warten.isf" ;Allgemeine "Bitte Warten" GUI
#include "..\Forms\ISN_Druckvorschau.isf" ;Druckvorschau GUI


;Immer zum Schluss (wegen ActiveX Object)
#include "..\Forms\ISN_Bugtracker.isf" ;Bugtracker GUI