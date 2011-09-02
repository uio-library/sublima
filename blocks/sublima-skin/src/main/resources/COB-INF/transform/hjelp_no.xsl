<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns="http://www.w3.org/1999/xhtml"
        version="1.0">
    <xsl:template name="hjelp_no">

      <a name="innhold"><br /></a><h1>Hjelpeside for Juridisk nettviser</h1>
      <p><h2>Innholdsfortegnelse</h2></p>
      <a href="#struktur">Strukturen i nettviseren</a><br />
      <a href="#navig">Navigasjon A-Å</a><br />
      <a href="#esok">Enkelt søk</a><br />
      <a href="#asok">Avansert søk</a><br />
      <a href="#dsok">Dypsøk</a><br />
      <a href="#avgrense">Avgrense søket</a><br /><br />
      
      <a name="struktur"><br /></a>
      <h2>Strukturen i nettviseren </h2>
      <p> Juridisk nettviser er en emneportal for juridiske ressurser
      på internett. Hver ressurs har en tittel som er lenken til selve
      ressursen. I tillegg har den en beskrivelse, utgiver, emneord,
      samt hvilke(t) språk ressursen finnes på.</p>
      <p> Visuelt er nettviseren delt i fire med statisk toppmeny og
	tre kolonner under. På startsiden er høyre og venstre kolonne
	tom, mens den midterste inneholder alfabetisk navigasjon,
	enkelt søkefelt med tilleggsfunksjoner, lenke til avansert
	søk, samt utvalgte emner.  Etter man har foretatt et søk eller
	navigert seg frem til ønsket emne finner man
	avgrensningsmuligheter i venstre kolonne, liste over
	ressursene i midterste kolonne, og emner evt. relaterte,
	overordnede eller mer spesifikke emner i høyre kolonne. (Dette
	avhenger av om man har valgt et emne eller om man søker
	generelt)</p>
      <h3> Emneord</h3>
      <p>Juridisk nettviser inneholder en rekke emneord. Disse er
      gruppert for å forenkle avgrensingsmulighetene. Gruppene av
      emneord er; jurisdiksjon, fagområde, rettskilder og emne. Under
      emne finner man emneord som ikke faller under de andre
      kategoriene, for eksempel er advokater, bibliotek og juridiske
      lenkesamlinger samlet i denne gruppen.</p>
      <p> Emneordene er ordnet hierarkisk med de mest generelle rett
	under hovedgruppen. Videre har en rekke av emneordene
	undergrupper.  For eksempel ligger Norge under Europa,
	arbeidsmiljø under arbeidsrett og så videre. Et emneord kan
	også ha relaterte emneord, for eksempel er emneordet
	forarbeider relatert til lover uten å være over eller
	underordnet. Hvis man er inne i emnet forarbeider så ser man i
	høyre kolonne at det står "Andre relevante emner" og under det
	står det lover. Dette er for å sikre en smidig navigasjon
	mellom emner som er relaterte. </p>
      <a href="#innhold">Innholdsfortegnelse</a><br />

      <a name="navig"><br /></a>
      <h2> Navigasjon A-Å</h2>
      <p>Under A-Å finner man samtlige emneord som er brukt i Juridisk
	nettviser, alfabetisk ordnet. Denne oversikten viser ikke
	relasjoner mellom emneordene.<br /> Hvis man for eksempel
	ønsker å finne litteratur i fulltekst: Trykk på <i>L</i>,
	trykk så på lenken merket <i>Litteratur i fulltekst</i>. Man
	får nå opp alle ressurser som har emneordet litteratur i
	fulltekst.</p>
      <a href="#innhold">Innholdsfortegnelse</a><br />

      <a name="esok"><br /></a>
      <h2> Enkelt søk</h2>
      <p>I søkefeltet, som blant annet finnes på forsiden foretas
      enkelt søk. Man søker da i emneord, tittel på ressursen,
      beskrivelser, utgivere og språk. Får den ikke treff i noen av
      disse foretar basen ett <a href="#dsok">dypsøk</a> </p>
      <p>Nettviseren har en autofullfør-funksjon. Det vil si at
      nettviseren gir søkeforslag fra emneordslisten når man begynner
      å skrive. Man kan velge ett av disse ved å trykke på
      emneordet.</p>
      <p>Nettviseren trunkerer automatisk etter ord. Det vil si at den
      søker med åpen ending. For eksempel vil et søk
      på <i>menneske</i> gi treff i emneordet menneskerettigheter samt
      ressurser hvor det forekommer ord som begynner på menneske. Hvis
      man ønsker å søke på ett eksakt ord, haker man av for <i>Eksakt
      ord</i> under søkefeltet</p>
      <p>Man kan søke på flere ord samtidig. Som standard setter
      nettviseren <i>og</i> mellom ordene. Det vil si at den gir treff
      hvor alle ordene forekommer. Ved å trykke på radioknappen ved
      siden av <i>Eller</i>, søkes det etter alle emneord og ressurser
      hvor minst ett av ordene forekommer. Dette kan være ønskelig ved
      søk på synonymer eller på flere språk. Også her kan man hake av
      for eksakt ord for å slå av trunkeringen for søket.</p>
      <p>For å søke på en frase setter man ordene i hermetegn. Da får
      man kun treff i dokumenter hvor den nøyaktige frasen
      forekommer. For eksempel vil "God tro" kun returnere treff hvor
      god tro forekommer som to ord etter hverandre.</p>
      <p> Hvis man ønsker at ressursene skal sorteres etter datoen de
      er lagt inn, må man velge dette fra nedtrekksmenyen "sorter
      etter", før man trykker søk.</p>
      <p>Etter at man har foretatt søket, får man en treffliste med
      alle ressurser som har søkeordet/søkeordene i en av de over
      nevnte felter. I høyre kolonne listes emneord opp under
      overskriften "Emner". Hvis man ønsker å liste alle ressursene
      innenfor et av emneordene så må man trykke på emneordet i høyre
      kolonne. Man kan også <a href="#avgrense">avgrense søket</a>
      sitt i venstre kolonne.</p>
      <a href="#innhold">Innholdsfortegnelse</a><br />
      
      <a name="asok"><br /></a>
      <h2> Avansert søk</h2>
      <p>For å komme til avansert søk, må man trykke på lenken
      "avansert søk" ved siden av søkefeltet for enkelt søk. Her kan
      man velge å søke etter ord og uttrykk i de spesifikke
      feltene. Søkefeltet merket emne har samme autofullfør-funksjonen
      som enkelt søk har. I tillegg er det autofullfør-funksjon i
      feltet for utgiver. Man kan søke i flere felt samtidig og
      avgrense til språk ved hjelp av nedtrekksmenyen. Hvis man ønsker
      å søke på en frase bruker man hermetegn som i enkelt søk.</p>
      <p> Det er et par viktige ting å huske på når man bruker
      avansert søk. For det første trunkerer ikke databasen
      automatisk. Ønsker man å trunkere, søke med åpen ending, må man
      sette en * på enden av ordet. For det andre foretar den
      ikke <a href="#dsok">dypsøk.</a></p>
      <a href="#innhold">Innholdsfortegnelse</a><br />
      
      <a name="dsok"><br /></a>
      <h2> Dypsøk</h2>
      <p>Et dypsøk foretar søk i alle ressursenes startsider. Ved å
      trykke på lenken til avansert søk, får man og opp muligheten for
      å ta et manuelt dypsøk. Det er viktig å huske på at det kun er
      siden det er lenket til i nettviseren som det søkes i, ikke hele
      nettstedet den siden ligger på.</p>
      <p>Søket i seg selv utføres på samme måte som
      i <a href="#esok">enkelt søk</a> med tanke på trunkering,
      frasesøk, synonymer m.m.</p>
      <a href="#innhold">Innholdsfortegnelse</a><br />
      
      <a name="avgrense"><br /></a>
      <h2> Avgrense søket</h2>
      <p>Når man har fått opp en liste med ressurser, kan man avgrense
      søket på:</p>
      <ul>
	<li>Emne
          <ul>
	    <li>Dette er emneord som omfavner en rekke
	    ressurser. Innenfor denne gruppen finner man ulike
	    institusjoner, veiledninger og andre emner som ikke er en
	    jurisdiksjon eller et fagområde.</li>
          </ul>
	</li>
	<li>Fagområde
          <ul>
	    <li>Her kan man avgrense på fagområde.</li></ul></li>
	<li>Jurisdiksjon
          <ul>
	    <li>Her kan man avgrense på jurisdiksjoner, samt FN.</li>
          </ul>
	</li>
	<li>Rettskilder
          <ul>
	    <li>Her kan man avgrense på type rettskilder</li>
          </ul>
	</li>
	<li>Utgiver</li>
	<li>Språk</li>
      </ul>
      <p> NB! En ressurs kan ha flere emner innen samme emnegruppe
      selv om emneordene ikke er relaterte.</p>
      <p> Avgrensningene finner man i venstre kolonne. Her listes
      avgrensingsordene alfabetisk og det er kun de ti første som
      vises. Hvis det er en lenke nederst i hver del merket <i>mer</i>
      finnes det flere avgrensningsmuligheter som man finner ved å
      trykke på <i>mer.</i> Ønsker man å gå tilbake til de 10 første
      trykker man på <i>skjul</i> nederst i gruppen. Hvis man ønsker å
      gjemme samtlige avgrensingsmuligheter i en gruppe trykker man på
      minustegnet ved siden av overskriften til gruppen. Ønsker man å
      vise de igjen trykker man på plusstegnet.</p>
      <p>For å avgrense, trykker man på emneordet, utgiveren eller
      språket man ønsker å avgrense til. Man kan avgrense videre så
      lenge noen av emneordene er aktive, det vil si at de er blå
      lenker. For å oppheve en avgrensing trykker man på <i>fjern</i>
      ved siden av avgrensningen man ønsker å fjerne.</p>
      
      <a href="#innhold">Innholdsfortegnelse</a><br /><br />

    </xsl:template>
</xsl:stylesheet>

