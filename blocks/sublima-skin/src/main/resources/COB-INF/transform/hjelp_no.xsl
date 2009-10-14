<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns="http://www.w3.org/1999/xhtml"
        version="1.0">
    <xsl:template name="hjelp_no">
        <h2>1 Startsiden</h2>
        <h3>1.1 Språkinnstilling</h3>
        <p>
            Språkinnstillingene for nettsiden finnes øverst til høyre på startsiden (Norsk Dansk Svenska).
        </p>
        <h3>1.2 Forstørret tekst</h3>
        <p>
            Du kan velge å forstørre teksten øverst til høyre på startsiden (A A A).
        </p>
        <h3>1.3 Søkeboksen</h3>
        <p>
            Du kan starte et søk ved å skrive ett eller flere ord i søkeboksen. Du kan velge om søket skal benytte seg
            av
            operatoren OG eller ELLER. Operator velges i radioknappene under søkefeltet. Forhåndsinnstilt operator er
            OG.
            Det betyr at hvis du søker med mer enn et ord vil du få treff på ressurser som inneholder alle søkeordene.
            Operatoren ELLER fører til treff på ressurser som inneholder minst ett av søkeordene.
        </p>
        <p>
            Hvis du vil søke på en frase (flere ord i en bestemt rekkefølge) må du omslutte frasen med ” ”.
            Ved å hake av for ”Eksakt ord” vil kun selve søkeordet benyttes. Hvis det ikke hakes av vil søket gi treff
            på
            alle ord som begynner med søkeordet, for eksempel vil søk på INFEKSJON også gi treff på INFEKSJONER.
        </p>
        <p>
            Du kan velge å få trefflisten sortert etter tittel eller registreringsdato (sist registrerte vises først).
            Sorteringsvalg må gjøres før du utfører søket.
        </p>
        <h3>1.4 A-Å emneordliste</h3>
        <p>
            Dette er inngangen til lister over de emnene som finnes i portalen. Under hver bokstav vises en alfabetisk
            liste. Klikk på et emne utfører et søk som fører til en emneside (mer om dette i punkt 2.2).
        </p>
        <h3>1.5 Avansert søk</h3>
        <p>

            Det avanserte søket tilbyr et søkegrensesnitt som gjør det mulig å bestemme hvilke felt du vil søke i. Du
            kan
            velge å søke på: Emne, Tittel, Beskrivelse og/eller Utgiver. Du kan også velge Medietype, Målgruppe og/eller
            Språk fra nedtrekkslister.
        </p>
        <h2>2 Resultatsider</h2>
        <h3>2.1 Resultat av søk</h3>
        <p>
            Når du utfører et søk, enten fra søkeboksen på startsiden eller fra Avansert søk, vil du i hovedfeltet på
            resultatsiden få en liste over aktuelle ressurser. Med ressurs mener vi en beskrivelse av en nettside. Hvis
            du
            klikker på en ressursens overskrift, vil du komme direkte til den nettsiden vi har beskrevet. Hvis du vil ha
            en
            nærmere beskrivelse av nettsiden kan du klikke på (Mer informasjon…)
            I feltet til venstre (Avgrens søk) vil du finne en del søkekriterier som du kan bruke til å avgrense søket
            ditt.
            Det kan for eksempel være at du bare ønsker å se ressurser på et bestemt språk, fra en bestemt utgiver, med
            et
            bestemt emne eller beregnet på en bestemt målgruppe.
        </p>
        <p>
            I feltet til høyre (Emner) vil du få en liste over de emnene som søket ditt har gitt treff i. Hvis du velger
            å
            klikke på et av disse emnene kommer du til en emneside. Se mer om dette i neste avsnitt.
        </p>
        <h3>2.2 Emnesider</h3>
        <p>
            Når du utfører et søk ved å klikke på et emne (enten fra forsiden, fra den alfabetiske listen eller fra en
            resultatside) kommer du til en emneside.
        </p>
        <p>
            I hovedfeltet på emnesiden vil det stå hvilket emne du har kommet fram til. I noen tilfeller vil du også få
            en
            beskrivelse av emnet og/eller en liste over synonymer. Du vil videre se en liste over ressurser som er
            koblet
            til dette emnet. Du kan være sikker på at ressursene som vises i denne listen omhandler det emnet du har
            valgt.
        </p>
        <p>
            I feltet til venste (Avgrens søk) vil du kunne avgrense hvilke ressurser du ønsker å se.
        </p>
        <p>
            I feltet til høyre (Se også) vises andre emner som på en eller annen måte er relatert til det emnet du har
            kommet fram til. Ved å klikke på et av disse emnene vil du komme til emnesiden for dette emnet.
        </p>
        <h3>2.3 Visningsformat</h3>
        <p>
            Både søkeresultatsidene og emnesidene vil som standard vises i formatet ”Kort beskrivelse”. Hvis du ønsker
            en
            nærmere beskrivelse av ressursene kan du velge ”Detaljert beskrivelse”.
        </p>
    </xsl:template>
</xsl:stylesheet>

