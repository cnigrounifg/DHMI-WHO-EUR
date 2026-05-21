# Action Planning – DHMI Paper (BIJ submission)

> **Note (post-publication update).** This document is a historical audit trail of the editorial revision process as of 13 May 2026. References to the companion paper's target journal — initially *Systems Research and Behavioural Science* (SRBS), later realigned to *Business Process Management Journal* (BPMJ) — reflect the state of planning at the time of writing. The target journal for the companion paper is currently under re-evaluation and is no longer fixed to either SRBS or BPMJ. See `CHANGELOG.md` and `README.md` for the authoritative current status. The body of this document is preserved verbatim for archival fidelity.

**Documento di lavoro**, basato su valutazione critica della bozza `00_DHMI_Paper_BIJ_Final.docx` e dell'appendice `Appendix_BIJ.docx` rispetto alla letteratura peer-reviewed indicizzata su Consensus (query lanciate il 13 maggio 2026).

Scopo: declinare in modo operativo le indicazioni significative emerse da Consensus e **non considerate** nella bozza, distinguendo tra (i) lacune potenzialmente **bloccanti in revisione** e (ii) raffinamenti che rafforzano la solidità della pubblicazione.

---

## 1. Sintesi della valutazione

Il paper colma un gap **genuino e ben circoscritto**: nessuna delle 8 query Consensus lanciate restituisce un composite operazionalizzato sui 74 indicatori del WHO Regional Office for Europe 2023 per i 53 Stati Membri. Il posizionamento rispetto a HIMSS EMRAM, GDHI, OECD DGI, DiPHMI (Maaß 2024) e Kan et al. 2025 è accurato. Le critiche che seguono non mettono in discussione l'originalità della contribution, ma identificano elementi della letteratura 2024–2025 che richiedono **integrazione esplicita** per rafforzare la solidità della submission.

I quattro rischi principali, in ordine di criticità:

1. **Concorrenti diretti non citati su EHDS/AI Act readiness** (Sezione 2 sotto)
2. **Trattamento liquidatorio del BoD/DEA come alternativa di weighting** (Sezione 3)
3. **Ceiling effects e self-report bias affrontati troppo brevemente** rispetto allo stato dell'arte metodologico (Sezione 4)
4. **Inquadramento del companion paper troppo vago**: la formulazione attuale "currently in preparation" sottostima la maturità del secondo lavoro (extended abstract IGCKM 2026 / SRBS già redatto, framework CAS distinto, 6 ipotesi formalizzate, uso esplicito dei cluster DHMI come grouping variable) ed espone la submission a richieste fuori-scope da parte dei reviewer (Sezione 5bis)

---

## 2. Gap critico: assenza di confronto con i tool di readiness EU 2024–2025

La bozza posiziona il DHMI rispetto a strumenti di maturità (HIMSS, GDHI, OECD DGI, DiPHMI, Kan). Ma negli ultimi 18 mesi è emerso un **secondo filone parallelo** orientato non alla maturity ma alla **EU regulatory readiness** (EHDS, AI Act, GDPR, Data Act, Cybersecurity Act), che il paper invoca come motivazione applicativa nell'Introduzione e nelle Practical implications ma non discute come letteratura comparativa.

### Riferimenti da integrare obbligatoriamente

- **Maaß, Zeeb, Rothgang et al. (2025)** – "Is the EU on track for digital public health? A checklist for assessing the national preparedness", *EJPH* 35(Suppl 1). 16 criteri di readiness su 5 domini (cybersecurity, workforce, infrastructure, cross-border exchange, strategic planning) per la valutazione nazionale di compliance verso EHDS, AI Act, GDPR, Cybersecurity Act, Data Act. *È il competitor più diretto sul lato "regulatory readiness" e proviene dagli stessi autori del DiPHMI già citato.*
- **Kessissoglou, Buttigieg, Knai et al. (2024)** – "Are EU member states ready for the European Health Data Space? Lessons learnt on the secondary use of health data from the TEHDAS Joint Action", *EJPH*. Country mapping su 12 Stati Membri usando il WHO Health Information System Assessment Tool adattato. *Operativizzazione effettiva su Stati Membri – il paper afferma che nessuna operazionalizzazione esiste, formulazione che va calibrata.*
- **Iorio, Gnesi, Boccia et al. (2025)** – "Data protection, interoperability and governance assessment tool: results from a proof-of-concept survey", *Frontiers in Digital Health*. Tool modulare DIGA per institutional self-assessment di EHDS-readiness. *Operativo, italiano, peer-reviewed.*
- **Kalodanis, Papapavlou et al. (2025)** – "Assessing the Readiness of European Healthcare Institutions for EU AI Act Compliance", *Studies in Health Technology and Informatics*. *Diretto antecedente sul lato AI Act, da citare quando la Sezione 1 e la Sezione 5 invocano l'AI Act.*
- **Cervera de la Cruz, Vermeulen et al. (2025)** – "Implementation of the European health data space: a qualitative study on expectations of health data experts from 23 countries", *Health Policy*. *Risorsa qualitativa complementare al DHMI: governance attesa vs governance misurata.*
- **Marelli, Ostuzzi et al. (2023)** – "The European health data space: Too big to succeed?", *Health Policy*. 48 citazioni. *Critica strutturale a EHDS che il paper deve menzionare quando posiziona il DHMI come "monitoring instrument" per EHDS.*

### Azioni concrete

1. **Sezione 2 (Theoretical Background)** – Aggiungere un paragrafo "EU regulatory readiness tools" subito prima o dopo la subsection "National digital health maturity: a critical review of prior instruments". Specificare che il DHMI e i checklist di readiness misurano **dimensioni diverse** (governance maturity ex-post vs regulatory readiness ex-ante), e che il DHMI ha valore **proprio nel fornire una baseline empirica** che i checklist di readiness assumono come dato.
2. **Tabella 1** – Aggiungere almeno la riga "Maaß checklist 2025 (16 criteri, 5 domini, EU MS)" e la riga "TEHDAS country mapping (12 MS, WHO HIS Toolkit adattato)" alla comparison, segnalando come "principal limitation vs. DHMI" l'assenza di standardizzazione su 74 indicatori e la copertura geografica più ristretta.
3. **Sezione 5.3 (Practical implications)** – Citare esplicitamente Maaß et al. 2025 come tool complementare quando si parla di EHDS participation readiness per i Low-Maturity EU MS (Croatia, Greece, Malta, Romania).
4. **Sezione 1 (Introduction)** – La frase "existing instruments are not equipped to satisfy at the scale of the full WHO European Region" va calibrata: il punto distintivo del DHMI **non è l'esistenza di tool comparabili** (esistono, su sottoinsiemi di paesi) ma la **standardizzazione WHO + copertura 53 paesi + indicatori 74 + protocollo robustness**.

---

## 3. Gap metodologico: trattamento del BoD/DEA

La Sezione 3.3 della bozza scrive: *"A benefit-of-the-doubt (BoD/DEA) scheme was additionally attempted but proved inapplicable in this setting: with eight constant-valued output dimensions, the DEA efficiency frontier collapses..."*

Questo è **tecnicamente corretto per la BoD classica** (Charnes-Cooper-Rhodes / Cherchye et al.). Ma la letteratura 2022–2025 ha sviluppato **almeno cinque varianti BoD** che affrontano direttamente il problema di non-applicabilità descritto:

- **Multi-Directional BoD** (Fusco 2022; Giambona et al. 2024): separa la selezione del benchmark dalla misura di efficienza, riducendo l'impatto del frontier collapse.
- **Sequential BoD** (Walheer 2024, *EJOR*): incorpora informazione panel/storica anche quando l'attuale cycle è degenerato.
- **Sub-group Dominance BoD** (Su et al. 2022, *EJOR*): affronta esplicitamente il problema del rank reversal sotto modifica del dataset.
- **DEA Without Explicit Inputs / Common Weights** (Bánhidi et al. 2023): applicato proprio al DESI dell'EU – metodologicamente molto vicino al DHMI.
- **BoD with discriminative-power weighting** (Libório et al. 2024, *Child Indicators Research*; *Entropy*): introduce framework che minimizza esplicitamente il problema della bassa discriminative power, che è esattamente il problema affrontato dal DHMI.

### Azioni concrete

5. **Sezione 3.3** – Riformulare il passaggio "BoD inapplicable" come segue: "*Standard BoD/DEA (Cherchye et al., 2007) is not applicable in this setting due to the collapse of the efficiency frontier under eight constant-valued output dimensions. Recent BoD extensions — including Multi-Directional BoD (Fusco, 2022), Sequential BoD (Walheer, 2024), Sub-group Dominance BoD (Su et al., 2022), and DEA-Without-Explicit-Inputs (Bánhidi et al., 2023) — partially address frontier-collapse and rank-reversal issues; their application to the present data structure is left to future research, as the discriminant variance is concentrated in a single domain regardless of the weighting frontier method.*"
6. **Sezione 6 (Future research)** – Aggiungere un'estensione esplicita: applicazione di BoD-extensions a successive ondate del WHO survey, quando l'aumento della varianza inter-paese renderà queste varianti informative.

Beneficio: **disinnesca la principale obiezione metodologica prevedibile** in revisione (i.e., "perché non avete provato le varianti recenti di BoD?").

---

## 4. Trattamento dei ceiling effects

Il finding centrale del paper – 8 domini su 10 con zero varianza inter-paese – è esattamente un **ceiling effect**, che la letteratura statistica recente tratta in modo molto più sviluppato rispetto a quanto la bozza riporta.

### Riferimenti da integrare

- **Liu, Wang, West (2020)** – "t-Test and ANOVA for data with ceiling and/or floor effects", *Behavior Research Methods*, 140 citazioni. Propone metodi basati su truncated normal distributions; rilevante perché il Mann-Whitney U usato dal paper è anch'esso degradato da ceiling/floor.
- **van der Linde, van Putten et al. (2025)** – "Reliability of data-driven versus expert-driven composite indicators in between-hospital comparisons", *BMJ Open*. Introduce **Item Response Theory (IRT)** per costruire composite continui in presenza di ceiling effects e propone la metrica di **rankability** (proporzione di varianza osservata tra unità non attribuibile al caso). *Direttamente applicabile al DHMI.*

### Azioni concrete

7. **Sezione 6 (Limitations)** – Aggiungere paragrafo: "*The structural concentration of cross-country variance in two domains (governance, literacy) reflects a ceiling effect (Liu et al., 2020). Standard composite-indicator methodology was not designed for this configuration. An alternative approach using Item Response Theory (van der Linde et al., 2025) could in principle produce a continuous latent score with higher rankability — defined as the proportion of inter-unit variance not attributable to chance — and represents a promising direction for future iterations of the DHMI once additional WHO survey cycles permit longitudinal IRT estimation.*"
8. **Sezione 4 (Findings)** – La frase "*eight of the ten WHO policy domains show zero cross-country variance*" va contestualizzata come ceiling effect strutturale e non come limitazione metodologica del DHMI, con riferimento esplicito alla letteratura sui ceiling effects.

---

## 5. Self-report bias: rafforzamento della Sezione Limitations

La Sezione 6 della bozza dedica una sola riga alla questione: *"the self-reported character of the WHO policy data introduces social desirability bias (Cresswell et al., 2024)"*. La letteratura recente offre evidenze molto più strutturate.

### Riferimenti da integrare

- **Parry, Davidson, Sewall et al. (2021)** – "A systematic review and meta-analysis of discrepancies between logged and self-reported digital media use", *Nature Human Behaviour*, 536 citazioni. Meta-analisi 106 effect sizes: self-report correla solo moderatamente con misure oggettive. *Anchor reference forte per la critica.*
- **Lira, Vergara, Beilock et al. (2022)** – "Large studies reveal how reference bias limits policy applications of self-report measures", *Scientific Reports*. Documenta come gruppi con standard impliciti diversi producano patterns paradossali nei confronti cross-group. *Direttamente applicabile a survey policy cross-country.*
- **Bhatia, Mossialos, Patel (2022)** – "Validity of self-reported hypertension in India", *JCH*. Caso paradigmatico di moderate agreement (kappa = 0.48) tra self-report e misurazione oggettiva in policy survey nazionali.
- **Cresswell et al. (2024)** – già citato; sottolineare che identifica esplicitamente self-report bias come uno dei "major challenges" delle valutazioni di digital maturity nazionali.

### Azioni concrete

9. **Sezione 6 (Limitations)** – Espandere la limitazione "self-reported character" in un paragrafo strutturato: (i) social desirability bias documentato in letteratura digital-health (Cresswell et al., 2024); (ii) reference bias inter-paese (Lira et al., 2022): paesi con standard impliciti diversi possono fornire risposte non commensurabili; (iii) discrepanza self-report vs misure logged in altri domini digital (Parry et al., 2021) suggerisce ordini di grandezza del bias; (iv) raccomandazione: future WHO survey cycles dovrebbero affiancare ai self-report **misure objective verifiabili** dove possibile (registrazione effettiva di strategie nazionali in repository EU/OECD).

---

## 5bis. Inquadramento esplicito del companion paper (status: extended abstract già redatto)

La bozza BIJ menziona in due punti (Sezione 1 e Sezione 6) un "companion paper currently in preparation". Questa formulazione **sottostima lo stato di avanzamento e la portata teorica** del secondo lavoro: l'extended abstract `51_IGCKM_SRBS.docx` (target conference IGCKM 2026, target journal *Systems Research and Behavioural Science*) è **già completato come abstract esteso** con framework teorico, ipotesi formalizzate, design metodologico e expected findings articolati. Questo cambia il modo in cui il companion va inquadrato nel paper BIJ.

### Profilo del companion paper

- **Titolo**: "Digital Health Governance as a Complex Adaptive System: Systemic Interdependencies, Institutional Feedback Mechanisms and Health System Performance in the WHO European Region"
- **Target journal**: *Systems Research and Behavioural Science* (filone CAS / systems thinking / behavioural science) — distinto dal target benchmarking/performance management di BIJ
- **Framework teorico**: Complex Adaptive Systems (Holland, 1992; Stacey, 2000), feedback-mechanism analysis (Ashby, 1956; Forrester, 1968), absorptive capacity behavioural theory (Cohen & Levinthal, 1990; Zahra & George, 2002; Simon, 1991; Levinthal & March, 1993)
- **Design**: PLS-SEM in SmartPLS v4 sui medesimi 53 paesi, con re-operazionalizzazione di subset di indicatori WHO come tre **latent reflective constructs**: codified regulatory governance (DH_13, DH_14, DH_15, DH_17), workforce absorptive capacity (DH_9, DH_10, DH_11), data-integration architecture (DH_46, DH_50, DH_67)
- **Variabili antecedenti aggiuntive** non presenti nel paper BIJ: World Governance Indicators (Government Effectiveness + Regulatory Quality + Rule of Law), GDP per capita PPP, public/private health expenditure
- **Variabili di outcome aggiuntive**: UHC effective coverage index e avoidable mortality rate per 100,000 (reversed)
- **Sei ipotesi formalizzate** (H1a–H3b) su direct paths, mediation (Zhao et al., 2010), serial mediation e moderated mediation (Hayes, 2015 index)
- **Uso esplicito dei cluster DHMI**: la multi-group analysis del companion utilizza i tre cluster del DHMI (rinominati nel companion come "Comprehensive Adopters", "Emerging Adopters", "Fragmented Adopters") come grouping variable categoriale importata dal paper BIJ

### Perché questo conta per la submission BIJ

Tre rischi editoriali concreti emergono dalla formulazione attuale ("currently in preparation"):

1. **Rischio di duplicate publication concern**: un reviewer attento potrebbe chiedere perché due paper sullo stesso dataset WHO non sono stati uniti. La risposta è solida — framework epistemologici **distinti e dichiarati** (composite measurement vs system structural modelling), target journal **complementari** (benchmarking vs systems research), unit of analysis **identica ma livello inferenziale diverso** (descriptive-comparative vs explanatory-structural) — ma va resa **esplicita nel paper**, non lasciata implicita.
2. **Rischio di under-citation reciproca**: BIJ peer reviewers possono interpretare la frase "in preparation" come segnale di precarietà. Citare il companion come **paper sottomesso/in via di sottomissione a SRBS, con titolo specifico**, segnala invece un programma di ricerca strutturato.
3. **Rischio di scope confusion**: senza chiarezza esplicita sul confine, il reviewer può chiedere a BIJ di anticipare elementi esplicativi (institutional quality, GDP moderation, mediation pathways) che sono **specificamente disegnati per essere fuori scope** in BIJ. Una formulazione netta del confine epistemologico **protegge** la submission BIJ.

### Riferimento al companion già presente nell'extended abstract

L'extended abstract IGCKM cita esplicitamente il paper BIJ: *"the empirical base developed in a companion paper (Curiello, Iannuzzi & Nigro, forthcoming, Benchmarking: An International Journal) – which constructs the Digital Health Maturity Index (DHMI)"*. La reciproca **deve** essere costruita nel paper BIJ con altrettanta precisione.

### Azioni concrete

12. **Sezione 1 (Introduction), penultimo paragrafo** – Sostituire la formulazione attuale (*"Questions concerning the socioeconomic and institutional determinants of DHMI scores, the causal mechanisms linking governance maturity to health system performance, and the theoretical interpretation of the observed cross-domain interdependencies fall outside the scope of this paper and are addressed in a companion paper currently in preparation."*) con una formulazione più strutturata, ad esempio:

    > *"Questions concerning the socioeconomic and institutional determinants of DHMI scores, the systemic mechanisms linking governance subsystems to health system performance, and the theoretical interpretation of the observed cross-domain interdependencies fall outside the scope of this paper. These questions are addressed in a companion paper (Curiello, Iannuzzi & Nigro, forthcoming) that re-operationalises selected WHO policy indicators as reflective latent constructs of a complex adaptive systems (CAS) model, tests six moderated-mediation hypotheses via PLS-SEM (Hair et al., 2019; Sarstedt et al., 2022), and uses the three DHMI maturity clusters as a grouping variable in multi-group analysis. The companion paper targets the **Systems Research and Behavioural Science** literature, with an epistemological frame – systemic interdependencies and feedback mechanisms (Holland, 1992; Ashby, 1956) – that is distinct from the composite-indicator benchmarking frame of the present paper."*

13. **Sezione 6 (Future research)** – Riformulare il riferimento al companion paper come **prima delle tre estensioni**, con tono che segnala "già in corso" piuttosto che "future research":

    > *"Three extensions of the present study are particularly warranted. The first – the systemic interpretation of DHMI patterns through a complex adaptive systems framework – is addressed in a parallel companion paper (Curiello, Iannuzzi & Nigro, forthcoming, Systems Research and Behavioural Science), which re-operationalises selected WHO indicators as reflective latent constructs of three co-evolving governance subsystems (codified regulatory governance, workforce absorptive capacity, data-integration architecture) and tests moderated-mediation hypotheses on the institutional-quality-to-health-outcomes pathway. The second extension – longitudinal application of the DHMI to successive WHO survey cycles – ..."*

14. **References** – Aggiungere l'entry per il companion paper: `Curiello, S., Iannuzzi, E., & Nigro, C. (forthcoming). Digital Health Governance as a Complex Adaptive System: Systemic Interdependencies, Institutional Feedback Mechanisms and Health System Performance in the WHO European Region. Systems Research and Behavioural Science.`
15. **Sezione 5 (Discussion)** – Quando si discute il finding della cross-domain Spearman correlation DH_13-DH_67 (regulatory ↔ big data, ρ = 0.671) e l'effect size r = 0.649 di DH_9 nel Mann-Whitney (DH_9, in-service digital training), aggiungere una nota che questi findings convergenti forniscono "empirical anchoring" per le ipotesi H2b (serial mediation regulatory → absorptive → integration) e H3b (substitution / requisite variety) testate strutturalmente nel companion. Questo costruisce **cross-paper evidence triangulation** e rafforza entrambi i lavori.
16. **Eventuale Author's Note / Acknowledgements** – Considerare una nota esplicita: *"The present paper and its companion (Curiello et al., forthcoming, SRBS) are part of a coordinated research programme using the WHO 2023 Regional Survey dataset under two distinct epistemological frames: composite-indicator benchmarking (this paper) and systems-theoretic structural modelling (companion paper). The two papers share the empirical dataset and the country sample but address methodologically and theoretically distinct research questions."* Questa nota – posizionata in modo trasparente – disinnesca anticipatamente qualsiasi preoccupazione editoriale.

### Beneficio atteso

Le modifiche sopra trasformano il companion paper da elemento di vulnerabilità potenziale (formulazione vaga, rischio di duplicate-publication concerns) in **asset strategico** della submission BIJ: dimostra programma di ricerca coordinato, mostra target journal complementare già identificato, e protegge BIJ da richieste fuori-scope.

---

## 5ter. Open Reproducibility Package: strategia per il repository GitHub

The paper states in §3.4 that *"the full reproducibility package is publicly accessible via a GitHub repository linked in the supplementary material."* Una folder `GitHub` è già predisposta nella directory di lavoro del progetto. To meet **FAIR principles** (Wilkinson et al., 2016, *Scientific Data*) and the **TOP Guidelines** (Nosek et al., 2015, *Science*) increasingly enforced by Emerald journals and by *Benchmarking: An International Journal* specifically, the repository should be structured to support three distinct audiences: (i) reviewers who need to verify computational reproducibility during peer review; (ii) future researchers who will apply the DHMI to successive WHO survey cycles; (iii) policy analysts who want to replicate the analysis on subsets of countries or alternative indicator selections.

### Recommended repository structure

```
DHMI-WHO-EUR/
├── README.md                          # Overview, citation, contact, badges
├── LICENSE                            # MIT for code, CC-BY 4.0 for data products
├── CITATION.cff                       # Machine-readable citation metadata
├── CHANGELOG.md                       # Version history
├── .zenodo.json                       # Zenodo DOI deposit metadata
│
├── data/
│   ├── raw/
│   │   ├── WHO_2023_survey_raw.csv    # Original WHO 2023 indicators (53×74)
│   │   └── data_dictionary.csv        # Indicator definitions, source URLs
│   ├── processed/
│   │   ├── DHMI_scores_final.csv      # Final DHMI scores (53 countries)
│   │   ├── domain_scores.csv          # 10 domain-level scores per country
│   │   └── cluster_assignments.csv    # k=3 cluster labels
│   └── external_validators/
│       ├── DESI_eHealth_2023.csv      # EU-27 DESI eHealth sub-index
│       └── WHO_UHC_2021.csv           # WHO UHC Service Coverage Index
│
├── code/
│   ├── 01_data_preparation.R          # Recoding to 0-3 scale, median imputation
│   ├── 02_dhmi_construction.R         # Equal-weight aggregation, 0-100 rescale
│   ├── 03_robustness_protocol.R       # Weight perturbation, PCA, missing data
│   ├── 04_cluster_analysis.R          # k-means, silhouette, Dunn index
│   ├── 05_spearman_fdr.R              # Pairwise correlations, Benjamini-Hochberg
│   ├── 06_lasso_regression.R          # LASSO with 10-fold + LOO-CV
│   ├── 07_mann_whitney_fdr.R          # MW U-tests, FDR-corrected
│   ├── 08_external_validity.R         # DESI and UHC convergent validity
│   └── 99_figures_tables.R            # Reproduce all figures and tables
│
├── outputs/
│   ├── figures/                       # Figures 1-4 (high-res PNG + source SVG)
│   ├── tables/                        # Tables 1-4 (CSV)
│   └── appendix/                      # Figure A1, Figure A2
│
├── companion_paper_bridge/
│   ├── construct_extraction.R         # Extracts DH_13/14/15/17, DH_9/10/11, DH_46/50/67
│   ├── cluster_grouping_variable.csv  # Cluster labels mapped to companion paper naming
│   └── README_bridge.md               # Documents the BIJ→SRBS data bridge
│
├── docs/
│   ├── methodology_notes.md           # Extended methodology rationale
│   ├── indicator_coding_decisions.md  # Document each 0-3 recoding choice
│   └── faq.md                         # Anticipate common reviewer questions
│
└── supplementary/
    ├── consensus_queries_log.md       # Documentation of literature review queries
    └── action_planning.md             # This planning document (for audit trail)
```

### Critical professional elements

1. **DOI assignment via Zenodo**: Connect the GitHub repository to Zenodo to mint a permanent DOI for each release. The DOI – not the GitHub URL – is what should be cited in the BIJ paper and what reviewers should be pointed to. GitHub repositories can be deleted or renamed; Zenodo DOIs are persistent. The `.zenodo.json` file allows full control over deposit metadata.
2. **Versioning with semantic tags**: Tag the version submitted to BIJ as `v1.0.0-bij-submission`, the revised version as `v1.1.0-bij-revision`, and the final accepted version as `v2.0.0-bij-published`. Each tag triggers a new Zenodo DOI version. This protects against the "moving target" concern raised by reviewers when authors update repositories after submission.
3. **Reproducibility verification**: Include a `Makefile` or a single `run_all.R` script that regenerates **every** figure, table, and number reported in the paper from the raw WHO data with one command. This is the single most powerful element a reviewer can test: if `Rscript run_all.R` produces identical outputs to those in the manuscript, the computational reproducibility claim is verified empirically.
4. **`renv` lockfile for R dependencies**: Use the `renv` package to capture exact versions of all R packages used in the analysis (the paper mentions R version 4.3.x). This ensures that the code remains executable even as upstream packages evolve. The `renv.lock` file should be committed at the root of the repository.
5. **Pre-print companion**: Deposit the BIJ submission version of the manuscript on **SSRN** or **OSF Preprints** with a DOI, cross-linked to the Zenodo data DOI. This establishes a public record of the work and demonstrates open science commitment without compromising the BIJ submission (Emerald permits pre-prints).
6. **README badges**: At minimum, the README should display badges for: (i) Zenodo DOI; (ii) license; (iii) R version compatibility; (iv) workflow status if continuous integration is used. These signal professional packaging at first glance.
7. **Bridge folder for the companion paper**: The `companion_paper_bridge/` directory makes explicit the data flow from the BIJ paper to the SRBS companion paper. This is the **single most professional move** the package can make: it transparently documents that the same dataset feeds two epistemologically distinct papers, with the cluster assignments and the indicator subsets that the SRBS paper will use as reflective constructs already extracted and labelled. Reviewers of both papers can verify that the empirical bridge is principled.

### Documentation of literature review and planning audit trail

The `supplementary/consensus_queries_log.md` should record the 8 Consensus queries used in the present Action Planning (with date, query string, and number of papers screened), and `supplementary/action_planning.md` should host this document itself. This creates an **audit trail** that supports the integrity of the editorial revision process: if a reviewer questions why a particular reference was added in revision, the audit trail shows the systematic literature review that motivated it.

### Integration with the paper

- **§3.4 (Robustness and external validity)**: Replace the current sentence *"the full reproducibility package is publicly accessible via a GitHub repository linked in the supplementary material"* with a more precise formulation citing the Zenodo DOI explicitly: *"All data, code, and analytical outputs supporting this study are openly available in a versioned, DOI-archived reproducibility package (Curiello et al., 2026; DOI: 10.5281/zenodo.XXXXXXX). The package includes the full WHO 2023 indicator dataset, all R scripts implementing the DHMI construction, robustness protocol, cluster analysis, LASSO regression, and Mann-Whitney tests, together with a `renv` lockfile pinning all package versions for long-term computational reproducibility."*
- **Data Availability Statement**: BIJ requires an explicit data availability statement. Recommended wording: *"The data that support the findings of this study are openly available in the DHMI-WHO-EUR repository at https://doi.org/10.5281/zenodo.XXXXXXX, including all raw indicators from WHO (2023), processed scores, and analytical code. The original WHO survey data are reproduced under WHO's open data licensing terms."*
- **References**: Add `Curiello, S., Iannuzzi, E., & Nigro, C. (2026). DHMI-WHO-EUR: Reproducibility package for the Digital Health Maturity Index [Data set and code]. Zenodo. https://doi.org/10.5281/zenodo.XXXXXXX`

### Sequencing and timing

The repository should reach `v1.0.0-bij-submission` status **before** the BIJ submission, not after. A repository that exists at submission time and is verifiable by reviewers is a substantively different signal than a promise of "code will be made available upon publication." Reviewers of indexed journals are increasingly skeptical of the latter formulation.

### Action items for the GitHub package

17. **Set up GitHub repository** with the structure above, populate with current code and data.
18. **Connect to Zenodo** and configure DOI minting on release.
19. **Add `renv` lockfile** capturing exact R package versions used in the analysis.
20. **Write `run_all.R`** that regenerates every output from raw data in one command.
21. **Document the BIJ↔SRBS data bridge** in `companion_paper_bridge/README_bridge.md`.
22. **Tag `v1.0.0-bij-submission`** before submitting the manuscript, and update §3.4 of the paper to cite the resulting Zenodo DOI.

---

## 6. Trattamento dell'overfitting LASSO

La bozza riporta correttamente R² gap = 0.180 e cautela nell'interpretare coefficient signs. Tuttavia, la letteratura metodologica recente offre strumenti specifici per gestire questa situazione.

### Riferimenti utili

- **Pavlou, Ambler et al. (2024)** – "Penalized Regression Methods With Modified Cross-Validation and Bootstrap Tuning Produce Better Prediction Models", *Biometrical Journal*. Metodo specifico (modified tuning + bootstrap tuning) per ridurre over-shrinkage in setting small-N.
- **Van Calster, van Smeden et al. (2020)** – "Regression shrinkage methods for clinical prediction models do not guarantee improved performance: Simulation study", *Statistical Methods in Medical Research*, 87 citazioni. Mostra che la variabilità del calibration slope sotto LASSO con piccoli N può essere severa.
- **Zhou, Bauer (2024)** – "Comparison of lasso and stepwise regression in psychological data", *Methodology*. Raccomanda 1SE rule (harsher shrinkage) per maggiore parsimonia e robustezza in piccoli N.
- **Bainter, McCauley et al. (2023)** – "Comparing Bayesian Variable Selection to Lasso Approaches", *Psychometrika*. Propone Stochastic Search Variable Selection (SSVS) come alternativa più robusta a LASSO in piccoli campioni.

### Azioni concrete

10. **Sezione 3** – Spostare la cautela sui coefficient signs (attualmente al §"LASSO regression, Mann-Whitney discrimination") in un sub-paragraph metodologico esplicito che (i) riconosce la variabilità documentata da Van Calster et al. 2020 per LASSO con n piccolo; (ii) menziona modified cross-validation tuning (Pavlou et al., 2024) come direzione di mitigazione; (iii) riposiziona LASSO esplicitamente come **descriptive selection** piuttosto che **inferential ranking** (in linea con la cautela già presente in bozza).
11. **Sezione 6 (Future research)** – Aggiungere SSVS Bayesian (Bainter et al., 2023) come direzione alternativa per il confronto convergence con Mann-Whitney.

---

## 7. Sintesi delle modifiche prioritarie

| # | Sezione | Modifica | Priorità | Effort stimato |
|---|---------|----------|----------|----------------|
| 1 | Sezione 2 + Tabella 1 | Aggiungere comparison con Maaß checklist 2025 e TEHDAS | **Alta** | 1–2 giornate |
| 2 | Sezione 1 | Calibrare claim di originalità rispetto a tool readiness EHDS/AI Act | **Alta** | mezza giornata |
| 3 | Sezione 3.3 | Riformulare BoD inapplicability menzionando varianti recenti | **Alta** | 1 giornata |
| 4 | Sezione 6 (Limits) | Espandere self-report bias con Parry 2021, Lira 2022 | **Alta** | 1 giornata |
| 5 | Sezione 1 + Sezione 6 + References | Riformulare riferimento al companion paper (SRBS), inserire titolo e framework CAS distinto, aggiungere entry references | **Alta** | mezza giornata |
| 6 | Sezione 5 (Discussion) | Cross-paper evidence triangulation: legare findings empirici BIJ alle ipotesi del companion (H2b, H3b) | **Alta** | mezza giornata |
| 7 | GitHub repository | Strutturare il package secondo §5ter, connettere a Zenodo per DOI, aggiungere `renv` lockfile, scrivere `run_all.R`, documentare bridge BIJ↔SRBS, taggare `v1.0.0-bij-submission` prima della submission | **Alta** | 3–4 giornate |
| 8 | §3.4 + Data Availability Statement + References | Aggiornare il riferimento al reproducibility package con DOI Zenodo, aggiungere DAS conforme a BIJ, citare il package come reference | **Alta** | 2 ore |
| 9 | Sezione 6 (Limits) | Riformulare ceiling effects con Liu 2020 e proporre IRT come futura direzione (van der Linde 2025) | **Media** | 1 giornata |
| 10 | Sezione 3 | LASSO instability discussion + modified CV tuning reference | **Media** | mezza giornata |
| 11 | Sezione 5.3 | Cross-reference con Kalodanis 2025 quando si menziona AI Act | **Media** | 1 ora |
| 12 | Author's Note / Acknowledgements | Nota esplicita sul programma di ricerca coordinato BIJ + SRBS | **Media** | 30 minuti |
| 13 | Sezione 6 (Future research) | SSVS Bayesian, BoD-extensions, IRT longitudinale | **Bassa-Media** | mezza giornata |

**Effort totale stimato**: 10–12 giornate-persona per implementare le priorità Alta + Media (l'aggiunta del reproducibility package professionale aggiunge circa 3–4 giornate-persona alla stima precedente di 7–8 giornate, ma è investimento one-shot che diventa asset permanente per tutto il programma di ricerca).

---

## 8. Cosa NON cambiare

Per chiarezza, le seguenti scelte della bozza **non richiedono modifiche** sulla base dell'evidenza Consensus:

- Equal weighting come baseline e PCA come alternative: l'argomento (i) interpretability, (ii) avoidance of arbitrary differentiation, (iii) alignment with WHO holistic framing è solido e coerente con Alqararah 2023 e Blancas et al. 2024 (citati correttamente).
- Cross-method convergence LASSO + Mann-Whitney FDR-corrected: l'argomento metodologico tiene; le critiche di cui sopra riguardano l'interpretazione, non l'approccio.
- Three-cluster typology k=3: k-means su DHMI 1-D vector, scelta via elbow + silhouette + Dunn è metodologicamente trasparente.
- Convergent validity bidirezionale (DESI negativa, UHC positiva): l'interpretazione "governance-side ≠ utilisation-side" è coerente con Marelli et al. 2023, Luca et al. 2021, Fernandes et al. 2024.
- Identificazione DH_1, DH_2, DH_3 come differenziatori strutturali: nessuna evidenza Consensus contraddice questo finding.

---

## 9. Domande aperte da discutere con i co-autori

1. ~~**Companion paper**: la bozza menziona un companion paper "currently in preparation"...~~ **→ Risolto**. L'extended abstract `51_IGCKM_SRBS.docx` per IGCKM 2026 / *Systems Research and Behavioural Science* è già redatto con framework CAS distinto, 6 ipotesi formalizzate, e uso esplicito dei cluster DHMI come grouping variable. Le azioni 12–16 nella Sezione 5bis declinano operativamente come inserirne la portata nel paper BIJ trasformandolo da elemento vago in asset strategico.
2. ~~**Open reproducibility package GitHub**: nella cartella `GitHub` predisposta...~~ **→ Risolto**. La strategia operativa è dettagliata nella nuova Sezione 5ter.
3. **Timeline submission BIJ e potenziale terzo paper metodologico (IRT)**: se il target è una sottomissione veloce a BIJ, le priorità Alta sopra sono sufficienti e l'IRT resta menzionato in Sezione 6 (Limitations / Future research) come direzione promettente. Se invece c'è margine per investire ulteriormente sul programma di ricerca, l'applicazione dell'**Item Response Theory** al dataset WHO 2023 potrebbe costituire un **terzo paper metodologico autonomo**, complementare a BIJ (composite-indicator benchmarking) e SRBS (CAS systems modelling). L'angolo specifico sarebbe: *advanced psychometric methods for ceiling-affected composite indicators in cross-country settings*, costruendo un latent score continuo con "rankability" superiore a quella ottenibile con aggregazione additiva in presenza di ceiling effects (van der Linde et al., 2025, *BMJ Open*). Target journal possibili: *Social Indicators Research*, *Journal of Official Statistics*, *Quality & Quantity*. Il paper estenderebbe il programma di ricerca da due a tre frame epistemologici sullo stesso dataset (additive measurement → systemic structural modelling → latent psychometric modelling), rafforzando la posizione del gruppo come autori di riferimento sul tema.
4. **Coordinamento submission BIJ ↔ SRBS**: conviene sottomettere prima a BIJ (in modo che il companion possa citare il paper BIJ come "forthcoming" o "in press" piuttosto che "submitted")? La citazione reciproca presente nell'extended abstract suggerisce che il design assume questa sequenza, ma vale la pena formalizzarla nel piano di sottomissione.

---

*Documento generato il 13 maggio 2026 e aggiornato in pari data per integrare l'extended abstract IGCKM 2026 / SRBS (file `51_IGCKM_SRBS.docx`). Basato su 8 query Consensus (oltre 150 paper letti negli abstract) e sull'analisi dell'extended abstract del companion paper. Le citazioni richiamano lavori indicizzati e direttamente verificabili nei risultati di ricerca. Nessuna citazione è stata inventata: ogni riferimento corrisponde a un risultato puntuale di Consensus o al contenuto verbatim dei documenti forniti.*
