import SwiftUI
import AVKit
import WebKit

@main
struct TheFloodArchiveApp: App {
    var body: some Scene {
        WindowGroup {
#if os(macOS)
            ArchiveView()
                .frame(minWidth: 980, minHeight: 680)
                .preferredColorScheme(.dark)
#else
            ArchiveView()
                .preferredColorScheme(.dark)
#endif
        }
#if os(macOS)
        .defaultSize(width: 1180, height: 780)
#endif
    }
}

private enum Page: String, CaseIterable, Identifiable {
    case briefing = "Mission Briefing"
    case sites = "Missions"
    case evidence = "Evidence Wall"
    case northAmerica = "North America"
    case media = "Field Media"
    case claimAudit = "Claim Audit"
    case conclusion = "Final Theory"

    var id: String { rawValue }
    var icon: String {
        switch self {
        case .briefing: "doc.text.magnifyingglass"
        case .sites: "location.north.circle"
        case .evidence: "point.3.connected.trianglepath.dotted"
        case .northAmerica: "map"
        case .media: "play.rectangle"
        case .claimAudit: "checkmark.seal"
        case .conclusion: "scope"
        }
    }
    var tabTitle: String {
        switch self {
        case .briefing: "Briefing"
        case .sites: "Missions"
        case .evidence: "Evidence"
        case .northAmerica: "America"
        case .media: "Media"
        case .claimAudit: "Claims"
        case .conclusion: "Theory"
        }
    }
}

private let compactTabs: [Page] = [.sites, .evidence, .northAmerica, .media, .claimAudit, .conclusion]

private struct Clue: Identifiable {
    let id: String
    let title: String
    let place: String
    let symbol: String
    let category: String
    let summary: String
    let detail: String
}

private struct ChallengeOption: Identifiable {
    let id: String
    let text: String
    let feedback: String
}

private struct FieldChallenge {
    let question: String
    let options: [ChallengeOption]
    let answerID: String
    let explanation: String
    let reasoningNote: String
}

private struct CaseConnection: Identifiable {
    let firstID: String
    let secondID: String
    let relation: String
    let basis: String
    var id: String { "\(firstID)|\(secondID)|\(relation)|\(basis)" }
    var pairID: String { "\(firstID)|\(secondID)" }
}

private struct ClueRecord {
    let region: String?
    let regionLabel: String
    let years: ClosedRange<Double>?
    let periodLabel: String
    let kind: String
    let kindLabel: String
}

private let linkBases = ["same-region", "overlapping-dates", "same-kind"]
private let differenceBases = ["different-region", "different-dates"]
private let explainedTheories: Set<String> = ["regional", "several", "noah", "global", "other"]

private struct EvidenceReference: Identifiable {
    let title: String
    let kind: String
    let url: String
    var id: String { title }
}

private struct AuditFile: Identifiable {
    let id: String
    let title: String
    let label: String
    let proClaim: String
    let observations: String
    let context: String
    var assessment = ""
    let references: [EvidenceReference]
}

private let auditFiles: [AuditFile] = [
    AuditFile(id: "megafloods", title: "Megafloods: Missoula and Altai", label: "STRONG EVIDENCE · REGIONAL EVENTS", proClaim: "The pro-flood case starts with a sound observation: ordinary rivers cannot explain every landscape. The Missoula floods and Altai outburst floods were immense, fast, and geomorphically transformative.", observations: "Field mapping, giant current ripples, flood gravel, erratic boulders, and stacked flood beds document repeated glacial-lake outbursts. USGS synthesis estimates dozens, likely over a hundred, Missoula floods across roughly 20–14 thousand years ago. Altai lake drainage is a separate, independently studied regional megaflood system.", context: "Flood advocates use these landscapes as real-world examples of how quickly catastrophic water can reshape vast regions, and scale the comparison up when discussing a worldwide Flood.", assessment: "The USGS review and the Altai studies describe repeated regional outburst floods from separate ice-dammed lakes, with their own basins, deposits, and ages. The authors treat them as regional Ice Age events, not as parts of one simultaneous worldwide flood.", references: [
        EvidenceReference(title: "USGS · Missoula and Bonneville floods review", kind: "GOVERNMENT GEOLOGY REVIEW", url: "https://www.usgs.gov/publications/missoula-and-bonneville-floods-a-review-ice-age-megafloods-columbia-river-basin"),
        EvidenceReference(title: "Agatova et al. · Last ice-dammed lake in the Kuray basin", kind: "PEER-REVIEWED RESEARCH · 2020", url: "https://doi.org/10.1016/j.earscirev.2020.103183"),
        EvidenceReference(title: "Herget et al. · Altai megafloods—The temporal context", kind: "PEER-REVIEWED REVIEW · 2020", url: "https://doi.org/10.1016/j.earscirev.2019.102995"),
        EvidenceReference(title: "Rudoy · Altai glacial superfloods", kind: "PEER-REVIEWED RESEARCH · 2002", url: "https://doi.org/10.1016/S1040-6182(01)00066-0")
    ]),
    AuditFile(id: "blacksea", title: "Black Sea: a candidate flood", label: "RAPID-INFLOW HYPOTHESIS", proClaim: "Ryan and Pitman’s 1997 research proposed that rising Mediterranean water breached the Bosporus and rapidly flooded a lower Black Sea basin in the early Holocene. In their later book, they argued that the event may have affected farming communities and inspired flood traditions.", observations: "Submerged shorelines, marine and freshwater sediments, and changing salinity are documented in the Black Sea basin. Ryan and Pitman used geological and archaeological clues to argue for rapid inflow.", context: "Ryan and Pitman read the evidence as a rapid regional flood that could lie behind ancient flood memories, including the Genesis account.", assessment: "The 1997 paper presents shoreline, sediment, and salinity evidence for a rapid regional inflow into the Black Sea basin. The link to ancient flood traditions appears in the authors’ later book as a historical interpretation; neither source describes a worldwide event.", references: [
        EvidenceReference(title: "Ryan et al. · Catastrophic flooding of the Black Sea", kind: "ORIGINAL RESEARCH · 1997", url: "https://doi.org/10.1016/S0025-3227(97)00007-8"),
        EvidenceReference(title: "Ryan & Pitman · Noah’s Flood (book, 1998)", kind: "AUTHOR’S SYNTHESIS AND HISTORICAL INTERPRETATION", url: "https://books.google.com/books/about/Noah_s_Flood.html?id=wr3YAAAAMAAJ"),
    ]),
    AuditFile(id: "seaLevel", title: "Drowned coasts after the Ice Age", label: "GLOBAL SEA-LEVEL RISE · SUBMERGED LANDSCAPES", proClaim: "After the Last Glacial Maximum, global sea level rose by roughly 120 metres as land ice melted. Former coastal plains and human landscapes were submerged; this could help explain why flood memories recur in coastal cultures.", observations: "Coral terraces, sediment cores, and dated shorelines record a large, multi-stage rise, including shorter meltwater pulses.", context: "Flood-tradition researchers suggest that memories of lost coastal landscapes may have travelled through generations and shaped flood stories in coastal cultures.", assessment: "The Barbados and global sea-level studies describe a rise of roughly 120 metres in several stages over many thousands of years after the Last Glacial Maximum. They document drowned coastlines, not a single flood event.", references: [
        EvidenceReference(title: "Nature Geoscience · Barbados-based LGM ice-volume estimate", kind: "PEER-REVIEWED RESEARCH · 2013", url: "https://www.nature.com/articles/ngeo1859"),
        EvidenceReference(title: "Peltier · Last Glacial Maximum to Holocene sea-level history", kind: "PEER-REVIEWED REVIEW · 2002", url: "https://doi.org/10.1016/S0277-3791(01)00084-1"),
        EvidenceReference(title: "Rohling et al. · Extended Barbados sea-level record", kind: "PEER-REVIEWED RESEARCH · 2007", url: "https://doi.org/10.1016/j.quascirev.2006.12.004")
    ]),
    AuditFile(id: "marineFossils", title: "Marine fossils high above today’s sea", label: "MARINE FOSSILS · ELEVATED STRATA", proClaim: "Marine fossils occur high in the Himalayas, Alps, and Colorado Plateau. Flood advocates point to them as evidence that water once covered land now at great altitude.", observations: "Marine fossils really are found in elevated rock formations. At Grand Canyon, the Kaibab Limestone and other units preserve marine fossils and were deposited in ancient seas.", context: "Marine fossils preserve traces of ancient seas in rock now found high above modern shorelines. The linked geology sources describe these fossil-bearing strata and the histories of the mountain belts around them; the Biblical encyclopedia uses elevated marine fossils in its flood argument.", assessment: "The cited geology sources explain that the fossils formed in ancient seas and that the Colorado Plateau and the Himalaya were raised to their present height later by tectonic uplift. In that reading, a fossil’s present elevation is not the elevation at which it formed.", references: [
        EvidenceReference(title: "National Park Service · Grand Canyon fossils", kind: "PARK GEOLOGY RESOURCE", url: "https://www.nps.gov/grca/learn/nature/fossils.htm"),
        EvidenceReference(title: "National Park Service · Grand Canyon geology and uplift", kind: "PARK GEOLOGY RESOURCE", url: "https://www.nps.gov/grca/learn/nature/grca-geology.htm"),
        EvidenceReference(title: "Han et al. · Tethys Himalaya marine sedimentary record", kind: "PEER-REVIEWED GEOLOGY RESEARCH · 2016", url: "https://doi.org/10.1016/j.palaeo.2016.05.012"),
        EvidenceReference(title: "Wang et al. · Constraints on Tibetan Plateau uplift history", kind: "PEER-REVIEWED PNAS RESEARCH · 2008", url: "https://doi.org/10.1073/pnas.0703595105"),
        EvidenceReference(title: "National Park Service · Kaibab Formation", kind: "PARK GEOLOGY RESOURCE", url: "https://www.nps.gov/zion/learn/nature/kaibab.htm"),
        EvidenceReference(title: "ICR · Marine fossils on today’s mountain ranges", kind: "CREATIONIST-PERSPECTIVE INTERPRETATION", url: "https://www.icr.org/node/7444")
    ]),
    AuditFile(id: "megasequences", title: "Continental layers: Tapeats and Coconino", label: "EXTENSIVE STRATA · FLOOD-GEOLOGY ARGUMENT", proClaim: "Flood geologists emphasize extensive sedimentary formations, large cross-beds, and paleocurrent directions. They argue that continent-scale water flows could deposit broad layers quickly.", observations: "Tapeats Sandstone is a broad Cambrian unit with documented marine, intertidal, and stream facies. The overlying Grand Canyon sequence includes distinct formations and trace fossils. Flood-geology authors interpret large Coconino cross-beds as evidence of powerful water currents.", context: "The Grand Canyon preserves broad sedimentary sequences, trace fossils, and cross-bedded formations. Flood geologists use the scale and geometry of these layers to discuss rapid, high-volume transport; the linked studies describe the rock structures and the settings interpreted by their authors.", assessment: "Hereford interprets the Tapeats as marine, intertidal, and stream deposits laid down as a Cambrian sea advanced, about 500 million years ago; conventional geology places the Coconino in the Permian and usually reads its cross-beds as wind-blown dunes. The water-laid reading of the Coconino is the creationist paper’s proposal.", references: [
        EvidenceReference(title: "Hereford · Deposition of the Tapeats Sandstone", kind: "PEER-REVIEWED RESEARCH · GSA BULLETIN", url: "https://doi.org/10.1130/0016-7606%281977%2988%3C199%3ADOTTSC%3E2.0.CO%3B2"),
        EvidenceReference(title: "ICR · Global sedimentary sequences and megaflood interpretation", kind: "CREATIONIST-PERSPECTIVE RESEARCH", url: "https://www.icr.org/article/global-stratigraphy-supports-progressive"),
        EvidenceReference(title: "Whitmore & Garner · Coconino subaqueous interpretation", kind: "CREATIONIST-PERSPECTIVE CONFERENCE PAPER · 2023", url: "https://publications.cedarville.edu/icc_proceedings/vol_9_2023/588/")
    ]),
    AuditFile(id: "polystrate", title: "Upright trees and rapid burial", label: "POLYSTRATE FOSSILS · RAPID-BURIAL ARGUMENT", proClaim: "Some fossil trunks cross multiple beds. Flood proponents argue that sediment must have accumulated quickly enough to bury the standing trees before they decayed.", observations: "At Joggins, Nova Scotia, researchers documented fossil forests and plant–sediment structures in Pennsylvanian floodplain strata. The fossil forests record interactions between plants and sediment; Flood-geology writers highlight upright trunks extending through several strata as evidence for rapid deposition.", context: "Flood-geology writers read upright trunks crossing several beds as snapshots of rapid sediment accumulation. Compare the fossil trunks, surrounding beds, and proposed mechanisms in the linked field and research sources.", assessment: "The Joggins sedimentology study reads the upright trunks as trees buried in place by repeated flood deposits on a Pennsylvanian floodplain, some of them rapid, with several forest levels growing one above another over time.", references: [
        EvidenceReference(title: "Rygel, Gibling & Calder · Joggins fossil-forest sediment structures", kind: "PEER-REVIEWED RESEARCH · SEDIMENTOLOGY", url: "https://doi.org/10.1111/j.1365-3091.2004.00635.x"),
        EvidenceReference(title: "Joggins Fossil Cliffs · UNESCO World Heritage", kind: "INSTITUTIONAL SITE", url: "https://whc.unesco.org/en/list/1285/"),
        EvidenceReference(title: "ICR · Polystrate trees at Joggins Fossil Cliffs", kind: "CREATIONIST-PERSPECTIVE INTERPRETATION", url: "https://www.icr.org/article/445/")
    ]),
    AuditFile(id: "dinosaurTissue", title: "Dinosaur soft tissue and collagen", label: "UNUSUAL PRESERVATION · PROPOSED MECHANISMS", proClaim: "Researchers have reported flexible vessel-like structures, cell-shaped features, and protein signals in dinosaur fossils. Flood proponents argue that such preservation is a clue to the history of these remains.", observations: "The structures and molecular signals are the subject of published laboratory studies. Schweitzer and colleagues proposed that iron and oxygen chemistry can slow degradation and help preserve or mask biomolecules; later work continues to test preservation mechanisms and identify what survives.", context: "The reported structures and proteins have prompted research into exceptional preservation, chemistry, and the history of fossil remains. Flood advocates consider these findings alongside burial and fossilization arguments; the linked laboratory papers describe the specimens and preservation mechanisms their authors investigated.", assessment: "The cited laboratory studies treat the structures as exceptional preservation and test chemical mechanisms, such as iron-driven cross-linking, that can slow decay. They do not use the finding to revise the specimens’ age, which is set by stratigraphy and independent dating.", references: [
        EvidenceReference(title: "Schweitzer et al. · T. rex soft-tissue structures", kind: "SCIENCE · ORIGINAL RESEARCH · 2005", url: "https://doi.org/10.1126/science.1108397"),
        EvidenceReference(title: "Schweitzer et al. · Iron and deep-time preservation", kind: "PROCEEDINGS OF THE ROYAL SOCIETY B · 2014", url: "https://doi.org/10.1098/rspb.2013.2741"),
        EvidenceReference(title: "Wiemann et al. · Mechanisms of soft-tissue preservation", kind: "PEER-REVIEWED RESEARCH · 2019", url: "https://doi.org/10.1098/rsos.191972")
    ]),
    AuditFile(id: "unconformities", title: "Flat contacts and missing time", label: "WIDESPREAD LAYERS · RAPID-DEPOSITION ARGUMENT", proClaim: "Flood advocates point to broad, apparently flat contacts between rock units and argue that they could have been deposited in quick succession, without long gaps for erosion.", observations: "Grand Canyon formations include broad sedimentary layers and the Great Unconformity, a contact between ancient crystalline basement and younger sedimentary rock. USGS describes unconformities as surfaces separating rock units with a record of missing geologic time; Flood-geology field reports emphasize the lateral continuity and relatively flat appearance of selected contacts.", context: "Flood geologists interpret extensive layers and selected flat contacts as products of successive, high-volume sediment flows during a major catastrophe. The linked sources document the contacts and present the Flood-geology interpretation.", assessment: "The USGS describes the Great Unconformity as a surface where a long interval of the rock record is missing, removed by erosion before younger sediments were laid down. In that interpretation, the contact marks elapsed time rather than continuous rapid deposition.", references: [
        EvidenceReference(title: "ICR · Grand Canyon: Exposing the Flood", kind: "CREATIONIST-PERSPECTIVE FIELD REPORT", url: "https://www.icr.org/node/18094"),
        EvidenceReference(title: "USGS · Stratified Rocks of the Grand Canyon", kind: "GOVERNMENT GEOLOGY MONOGRAPH", url: "https://pubs.usgs.gov/pp/0669/report.pdf"),
        EvidenceReference(title: "USGS · Geology of Grand Canyon National Park", kind: "GOVERNMENT GEOLOGY RESOURCE", url: "https://www.usgs.gov/geology-and-ecology-of-national-parks/geology-grand-canyon-national-park")
    ]),
    AuditFile(id: "folds", title: "Bent strata and the Kaibab fold", label: "BENT ROCK LAYERS · FOLDING ARGUMENT", proClaim: "Flood advocates cite sharply bent layers, including near the East Kaibab monocline, and argue that rock could bend without breaking only while sediment was still soft.", observations: "The East Kaibab monocline is a prominent fold in Grand Canyon strata. Structural studies map faults through the fold and interpret it as fault-propagation folding during regional compression; Flood-geology writers discuss bent strata as part of their rapid-deformation argument.", context: "Flood-geology writers use bent strata to discuss when and how thick rock sequences were deformed. The structural study maps the fold and associated faults; compare those observations with the interpretation in the linked Flood-geology paper.", assessment: "Tindall and Davis map faults beneath the East Kaibab monocline and interpret the fold as forming when deeper faults moved during later regional compression. In their reading, the layers were already rock when they bent, with fractures and faults accommodating the fold.", references: [
        EvidenceReference(title: "Tindall & Davis · East Kaibab monocline fault-propagation folding", kind: "PEER-REVIEWED STRUCTURAL GEOLOGY · 1999", url: "https://doi.org/10.1016/S0191-8141(99)00089-9"),
        EvidenceReference(title: "Snelling · Flood interpretation of Grand Canyon folds", kind: "CREATIONIST-PERSPECTIVE PAPER", url: "https://www.biblicalcreationtrust.org/pdf/e-origins_vol4_pp22-25_flood_geology_explains_grand_canyon_folds.pdf")
    ]),
    AuditFile(id: "cpt", title: "Catastrophic Plate Tectonics", label: "FLOOD-MODEL PROPOSAL · RAPID PLATE MOTION", proClaim: "John Baumgardner’s model proposes runaway subduction, rapid movement of plates, seafloor volcanism, rising oceans, and intense rainfall during a Genesis Flood.", observations: "The model has been presented in the Proceedings of the International Conference on Creationism and combines plate-motion, volcanic, ocean, and atmospheric processes into one proposed Flood mechanism.", context: "Follow the authors’ proposed chain of events through the cited model and compare its predicted effects with the geological clues elsewhere in the archive.", assessment: "The model is published in creationist conference proceedings, not in a mainstream geophysics journal. Measured present-day plate motions are a few centimetres per year, and the runaway-subduction model has not been adopted outside Flood geology.", references: [
        EvidenceReference(title: "Baumgardner · Catastrophic Plate Tectonics: physics behind the model", kind: "CREATIONIST-PERSPECTIVE RESEARCH · 2003", url: "https://www.icr.org/article/catastrophic-plate-tectonics-flood"),
    ]),
    AuditFile(id: "rate", title: "RATE and helium in zircon", label: "HELIUM-DIFFUSION ARGUMENT · RATE PROJECT", proClaim: "The RATE project reported helium retained in zircons from deep granite and argued that diffusion calculations imply a recent age and accelerated radioactive decay.", observations: "Helium diffusion in zircon is measurable and is used in thermochronology. The RATE project reported retained helium and used diffusion calculations as part of its young-age argument.", context: "The RATE team’s argument links measured helium retention, crystal properties, radiation damage, and a proposed temperature history. Compare their published calculations with the laboratory research linked here as you assess this line of evidence.", assessment: "The cited thermochronology studies show that helium diffusion in zircon depends strongly on radiation damage and temperature history. Mainstream geochronology does not accept the RATE results as evidence of accelerated radioactive decay.", references: [
        EvidenceReference(title: "Humphreys · RATE zircon helium diffusion study", kind: "CREATIONIST-PERSPECTIVE RESEARCH · RATE II · 2005", url: "https://www.icr.org/node/8376"),
        EvidenceReference(title: "Guenthner et al. · Radiation damage and helium diffusion in zircon", kind: "PEER-REVIEWED THERMOCHRONOLOGY · 2013", url: "https://doi.org/10.2475/03.2013.01"),
        EvidenceReference(title: "Guenthner et al. · Zircon damage-annealing model", kind: "PEER-REVIEWED RESEARCH · 2021", url: "https://doi.org/10.1029/2019GC008757"),
    ]),
    AuditFile(id: "fossilOrder", title: "Fossil order and radiometric ages", label: "MULTIPLE INDEPENDENT LINES OF EVIDENCE", proClaim: "Flood proponents suggest ecological zonation, mobility, habitat, and water transport could influence which organisms were buried first, so fossil order deserves investigation rather than a slogan.", observations: "Across many regions, fossil assemblages occur in a reproducible succession. Radiometric ages from suitable igneous minerals bracket sedimentary strata; fossil succession and isotope dating are related but distinct methods.", context: "Flood-geology authors propose that the order of burial followed ecological zones, habitat elevation, mobility, and sorting by moving water during the Flood, rather than a long succession of ages.", assessment: "The Smithsonian and the International Commission on Stratigraphy describe a consistent fossil succession cross-checked against radiometric dates from volcanic layers. Together they are used to build a geologic time scale spanning hundreds of millions of years.", references: [
        EvidenceReference(title: "ICR · The five rules of Flood paleontology", kind: "CREATIONIST-PERSPECTIVE RESEARCH", url: "https://www.icr.org/article/13444/"),
        EvidenceReference(title: "Smithsonian · Stratigraphy, fossil succession, and dating", kind: "MUSEUM SCIENCE RESOURCE", url: "https://humanorigins.si.edu/evidence/dating"),
        EvidenceReference(title: "International Commission on Stratigraphy · Geologic time scale", kind: "INTERNATIONAL SCIENTIFIC STANDARD", url: "https://stratigraphy.org/" )
    ]),
    AuditFile(id: "birthFossil", title: "A fossil caught giving birth", label: "EXCEPTIONAL FOSSIL · CHINA", proClaim: "A Chaohusaurus fossil preserves a mother, two embryos, and a neonate in a birth-position arrangement. Flood advocates include such snapshots among examples of rapid burial during catastrophe.", observations: "The authors report three associated young: one inside the mother, one partly emerging, and one outside. They conclude that the mother likely died in labor; they also note that the rock is marine and infer that birth most likely occurred underwater.", context: "The specimen comes from China and dates to the Early Triassic, around 248 million years ago. The paper documents the fossil and the authors’ interpretation. Flood advocates read the preserved birth scene as an example of sudden burial during catastrophic events.", assessment: "Motani and colleagues interpret the fossil as a mother that died while giving birth in an Early Triassic sea, about 248 million years ago. The paper documents one burial event and does not discuss Noah’s Flood.", references: [
        EvidenceReference(title: "Motani et al. · Chaohusaurus embryos and birth position", kind: "PEER-REVIEWED RESEARCH · PLOS ONE · 2014", url: "https://doi.org/10.1371/journal.pone.0088640"),
        EvidenceReference(title: "PLOS ONE · Full article and figures", kind: "OPEN-ACCESS ORIGINAL PAPER", url: "https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0088640")
    ]),
    AuditFile(id: "grassMammoth", title: "The mammoth with grass in its mouth", label: "BEREZOVKA · SIBERIA · PRESERVED LAST MEAL", proClaim: "Insight on the Scriptures reports the argument that the frozen mammoth and its vegetation are ‘convincing evidence of a sudden, catastrophic global flood.’ The Berezovka specimen’s preserved last meal is documented separately by the Smithsonian and an expedition account.", observations: "The Smithsonian documents grasses and other plants in the mammoth’s stomach. Pfizenmayer’s expedition account also describes vegetation preserved in the mouth. The specimen was recovered from Siberian permafrost, which preserved soft tissue and plant material.", context: "The Biblical encyclopedia reports this as a Flood argument. The Smithsonian and expedition sources describe the specimen and its preserved vegetation; compare those records with the interpretation presented in *Insight on the Scriptures*.", assessment: "The Smithsonian record documents the preserved stomach contents of one Siberian mammoth. How quickly the animal died and was buried is interpreted from the carcass and its setting; the specimen record does not describe a worldwide flood.", references: [
        EvidenceReference(title: "Insight on the Scriptures · ‘Flood of Noah’s Day’", kind: "BIBLICAL ENCYCLOPEDIA · ARGUMENT SOURCE", url: "https://www.jw.org/en/library/books/Insight-on-the-Scriptures/Flood-of-Noahs-Day/"),
        EvidenceReference(title: "Smithsonian · Berezovka woolly mammoth and stomach contents", kind: "MUSEUM RESEARCH NOTE", url: "https://www.si.edu/collections/snapshot/berezovka-woolly-mammoth-flesh-jar"),
        EvidenceReference(title: "Pfizenmayer · Siberian mammoths and the Berezovka expedition", kind: "HISTORICAL EXPEDITION ACCOUNT · 1939", url: "https://rcin.org.pl/dlibra/publication/3640/edition/3278/les-mammouths-de-siberie-le-decouverte-de-cadavres-de-mammouths-prehistoriques-sur-les-bords-de-la-berezovka-et-de-la-sanga-iourakh-pfizenmayer-eugen-wilhelm-1869-1941?language=pl"),
        EvidenceReference(title: "ICR · Mammoths and rapid burial in the Flood model", kind: "CREATIONIST-PERSPECTIVE INTERPRETATION", url: "https://www.icr.org/article/mammoths-testify-flood")
    ]),
    AuditFile(id: "mammothExtinction", title: "The mammoth die-off argument", label: "MAMMOTH REMAINS · SUDDEN-CATASTROPHE ARGUMENT", proClaim: "Insight on the Scriptures reports mammoths and other animals found frozen with undigested stomach contents and presents a sudden catastrophe as an interpretation of these remains.", observations: "Permafrost preserves mammoth remains and plant material. Yukon sedimentary ancient-DNA records document ecological change across thousands of years, while fossil specimens provide local snapshots of animals and their environments.", context: "The Biblical encyclopedia brings frozen carcasses, preserved stomach contents, and sudden burial together as a catastrophic-flood argument. Compare the mammoth specimen records with the Yukon environmental sequence and decide how the clues relate.", assessment: "The Yukon ancient-DNA study describes the mammoth steppe changing, and mammoths declining, over thousands of years at the end of the Ice Age rather than in a single sudden event.", references: [
        EvidenceReference(title: "Insight on the Scriptures · ‘Deluge’", kind: "BIBLICAL ENCYCLOPEDIA · ARGUMENT SOURCE", url: "https://www.jw.org/en/library/books/Insight-on-the-Scriptures/Deluge/"),
        EvidenceReference(title: "Smithsonian · Berezovka mammoth stomach contents", kind: "MUSEUM SPECIMEN RECORD", url: "https://www.si.edu/collections/snapshot/berezovka-woolly-mammoth-flesh-jar"),
        EvidenceReference(title: "Murchie et al. · Mammoth-steppe change in Yukon", kind: "PEER-REVIEWED RESEARCH · NATURE COMMUNICATIONS · 2021", url: "https://www.nature.com/articles/s41467-021-27439-6")
    ]),
    AuditFile(id: "floodTraditions", title: "Flood stories across cultures", label: "HUNDREDS OF ACCOUNTS · SHARED-MEMORY ARGUMENT", proClaim: "Insight on the Scriptures, a Biblical encyclopedia, notes that ‘hundreds of such legends are known’ and presents their shared features as an argument for a common ancestral memory.", observations: "Ancient Near Eastern flood narratives survive in cuneiform and biblical texts. The Biblical encyclopedia reports hundreds of flood traditions and draws attention to shared features such as a warning, survival, and a changed world.", context: "The encyclopedia presents widespread flood traditions and their shared elements as clues to a common ancestral memory. Compare those motifs with the ancient texts and geological cases assembled elsewhere in the archive.", assessment: "The comparative studies document many flood traditions and examine their similarities and differences. They weigh several explanations, including local floods, the transmission of texts between cultures, and shared literary motifs, and do not treat the traditions as proof of one worldwide event.", references: [
        EvidenceReference(title: "Insight on the Scriptures · ‘Flood of Noah’s Day’", kind: "BIBLICAL ENCYCLOPEDIA · ARGUMENT SOURCE", url: "https://www.jw.org/en/library/books/Insight-on-the-Scriptures/Flood-of-Noahs-Day/"),
        EvidenceReference(title: "Chen · The Primeval Flood Catastrophe in Mesopotamian Traditions", kind: "OXFORD ACADEMIC · ANCIENT NEAR EASTERN STUDIES", url: "https://doi.org/10.1093/acprof:oso/9780199676200.001.0001"),
        EvidenceReference(title: "Magnone · Floodlighting the Deluge: Traditions in Comparison", kind: "PEER-REVIEWED COMPARATIVE STUDY", url: "https://publicatt.unicatt.it/handle/10807/118803"),
        EvidenceReference(title: "Oxford Academic · Genesis and ancient Near Eastern flood accounts", kind: "SCHOLARLY COMPARATIVE STUDY", url: "https://academic.oup.com/book/35373/chapter-abstract/301258660")
    ]),
    AuditFile(id: "waterBudget", title: "Could today’s water cover a smoothed Earth?", label: "REPORTED ARGUMENT · MATHEMATICAL THOUGHT EXPERIMENT", proClaim: "Insight on the Scriptures frames the calculation with the phrase ‘If the earth’s surface was smoothed out’; it says the resulting water layer would be about 2,400 metres deep.", observations: "USGS estimates about 1.338 billion cubic kilometres of ocean water. Dividing that approximate volume by Earth’s roughly 510 million square kilometres of surface gives about 2.6 kilometres as a simplified average layer.", context: "This thought experiment compares the total volume of ocean water with Earth’s surface area after smoothing its topography. The Biblical encyclopedia uses the resulting depth as one argument in its discussion of the Flood’s water supply.", assessment: "The calculation is a scale comparison. NOAA’s hypsographic data show that Earth’s surface is not smooth: ocean basins lie kilometres below sea level and continents rise above it, so the thought experiment removes today’s topography by assumption.", references: [
        EvidenceReference(title: "Insight on the Scriptures · ‘Flood of Noah’s Day’", kind: "BIBLICAL ENCYCLOPEDIA · ARGUMENT SOURCE", url: "https://www.jw.org/en/library/books/Insight-on-the-Scriptures/Flood-of-Noahs-Day/"),
        EvidenceReference(title: "USGS · How much natural water is there?", kind: "GOVERNMENT DATA SUMMARY", url: "https://www.usgs.gov/faqs/how-much-natural-water-there"),
        EvidenceReference(title: "NOAA NCEI · Earth surface hypsographic curve", kind: "GOVERNMENT BATHYMETRY AND TOPOGRAPHY DATA", url: "https://www.ncei.noaa.gov/sites/default/files/2023-01/Hypsographic%20Curve%20of%20Earth%E2%80%99s%20Surface%20from%20ETOPO1.pdf")
    ]),
    AuditFile(id: "arkCapacity", title: "The Ark’s dimensions and capacity", label: "SCRIPTURAL DIMENSIONS · CAPACITY ARGUMENT", proClaim: "Insight on the Scriptures describes the Ark as a ‘rectangular chestlike vessel’ and argues from its dimensions and estimated usable volume that it could carry representatives of animal ‘kinds.’", observations: "Genesis 6:15 gives 300 × 50 × 30 cubits; the text also describes three decks. Converting those dimensions into cubic metres requires choosing a cubit length and making assumptions about hull shape, usable space, animal categories, food, water, ventilation, and waste.", context: "The Biblical encyclopedia uses the Ark’s stated dimensions, estimated interior volume, and animal ‘kinds’ to discuss capacity. Follow the calculation and its assumptions alongside the textual description in Genesis.", assessment: "The dimensions come from the biblical text; no excavated vessel has been measured. Capacity figures depend on the chosen cubit, hull shape, and animal categories, and no independent study cited here tests the encyclopedia’s estimates.", references: [
        EvidenceReference(title: "Insight on the Scriptures · ‘Ark’", kind: "BIBLICAL ENCYCLOPEDIA · ARGUMENT SOURCE", url: "https://www.jw.org/en/library/books/Insight-on-the-Scriptures/Ark/"),
        EvidenceReference(title: "Genesis 6 · Ark dimensions in the biblical text", kind: "PRIMARY SCRIPTURAL TEXT", url: "https://www.jw.org/en/library/bible/nwt/books/genesis/6/")
    ]),
    AuditFile(id: "watersAbove", title: "The proposed source of the Flood’s water", label: "REPORTED ARGUMENT · SCRIPTURAL COSMOLOGY", proClaim: "Insight on the Scriptures describes proposed explanations for the waters above and below as ‘only speculative.’ The encyclopedia presents the Genesis account’s water source while acknowledging that the mechanism is not explained in the text.", observations: "The cited passages are part of the Genesis creation and Flood account. The encyclopedia reports the biblical description; it does not provide an independently measured physical reservoir for the water.", context: "‘Only speculative’ is the Biblical encyclopedia’s own characterization of proposed mechanisms, not a claim that the Flood account itself is speculative. This entry records the scriptural argument and the publication’s stated limit without presenting an unmeasured water source as a scientific finding.", assessment: "The encyclopedia itself calls the proposed mechanisms ‘only speculative.’ No cited scientific source identifies a physical reservoir for this water, so the entry remains a scriptural argument rather than a measured observation.", references: [
        EvidenceReference(title: "Insight on the Scriptures · ‘Deluge’", kind: "BIBLICAL ENCYCLOPEDIA · ARGUMENT SOURCE", url: "https://www.jw.org/en/library/books/Insight-on-the-Scriptures/Deluge/"),
        EvidenceReference(title: "Genesis 1 · The expanse and waters", kind: "PRIMARY SCRIPTURAL TEXT", url: "https://www.jw.org/en/library/bible/nwt/books/genesis/1/"),
        EvidenceReference(title: "Genesis 7 · The Flood begins", kind: "PRIMARY SCRIPTURAL TEXT", url: "https://www.jw.org/en/library/bible/nwt/books/genesis/7/")
    ]),
    AuditFile(id: "scripturalWitness", title: "The Bible’s later witnesses to the Flood", label: "REPORTED ARGUMENT · BIBLICAL TESTIMONY", proClaim: "Insight on the Scriptures argues that later Bible writers, including Jesus, treated Noah and the Flood as historical and used the account in teaching. This is the encyclopedia’s scriptural argument for the Flood’s historicity.", observations: "The Deluge article cites Psalm 29, Isaiah 54, Ezekiel 14, Luke 3, Matthew 24, Luke 17, Hebrews 11, 1 Peter 3, and 2 Peter 2–3. The Flood of Noah’s Day article also refers to John 8:58 in support of its claim that Jesus was an eyewitness in heaven. These are textual and theological arguments in the encyclopedia, not geological measurements.", context: "The Biblical encyclopedia presents the later Bible references as confirmation of the Genesis account. This is a theological and textual argument, distinct from physical evidence such as dated deposits or fossils.", assessment: "These passages show how later Bible writers used the account. They are textual and theological evidence; they do not provide dated deposits or other physical measurements.", references: [
        EvidenceReference(title: "Insight on the Scriptures · ‘Flood of Noah’s Day’", kind: "BIBLICAL ENCYCLOPEDIA · SCRIPTURAL ARGUMENT", url: "https://www.jw.org/en/library/books/Insight-on-the-Scriptures/Flood-of-Noahs-Day/"),
        EvidenceReference(title: "Insight on the Scriptures · ‘Noah’", kind: "BIBLICAL ENCYCLOPEDIA · SCRIPTURAL ARGUMENT", url: "https://www.jw.org/en/library/books/Insight-on-the-Scriptures/Noah/"),
        EvidenceReference(title: "Isaiah 54 · Noah reference", kind: "PRIMARY SCRIPTURAL TEXT", url: "https://www.jw.org/en/library/bible/nwt/books/isaiah/54/"),
        EvidenceReference(title: "Psalm 29 · Jehovah over the Deluge", kind: "PRIMARY SCRIPTURAL TEXT", url: "https://www.jw.org/en/library/bible/nwt/books/psalms/29/"),
        EvidenceReference(title: "John 8 · Jesus’ statement about his prehuman existence", kind: "PRIMARY SCRIPTURAL TEXT", url: "https://www.jw.org/en/library/bible/nwt/books/john/8/"),
        EvidenceReference(title: "Ezekiel 14 · Noah, Daniel, and Job", kind: "PRIMARY SCRIPTURAL TEXT", url: "https://www.jw.org/en/library/bible/nwt/books/ezekiel/14/"),
        EvidenceReference(title: "Matthew 24 · Jesus refers to Noah", kind: "PRIMARY SCRIPTURAL TEXT", url: "https://www.jw.org/en/library/bible/nwt/books/matthew/24/"),
        EvidenceReference(title: "Luke 17 · Jesus refers to Noah", kind: "PRIMARY SCRIPTURAL TEXT", url: "https://www.jw.org/en/library/bible/nwt/books/luke/17/"),
        EvidenceReference(title: "Luke 3 · Noah in Jesus’ genealogy", kind: "PRIMARY SCRIPTURAL TEXT", url: "https://www.jw.org/en/library/bible/nwt/books/luke/3/"),
        EvidenceReference(title: "Hebrews 11 · Noah’s faith", kind: "PRIMARY SCRIPTURAL TEXT", url: "https://www.jw.org/en/library/bible/nwt/books/hebrews/11/"),
        EvidenceReference(title: "1 Peter 3 · Noah and the Flood", kind: "PRIMARY SCRIPTURAL TEXT", url: "https://www.jw.org/en/library/bible/nwt/books/1-peter/3/"),
        EvidenceReference(title: "2 Peter 2 · Noah as a preacher", kind: "PRIMARY SCRIPTURAL TEXT", url: "https://www.jw.org/en/library/bible/nwt/books/2-peter/2/"),
        EvidenceReference(title: "2 Peter 3 · The Flood account", kind: "PRIMARY SCRIPTURAL TEXT", url: "https://www.jw.org/en/library/bible/nwt/books/2-peter/3/")
    ]),
    AuditFile(id: "fossilizationPressure", title: "Could water pressure fossilize organisms quickly?", label: "REPORTED ARGUMENT · HISTORICAL ESTIMATE", proClaim: "Insight on the Scriptures reports a pressure estimate of two tons per square inch and cites Donald W. Patten’s 1966 book when discussing rapid fossilization under catastrophic conditions.", observations: "The Biblical encyclopedia cites Donald W. Patten’s 1966 book for the pressure estimate and its proposed role in rapid fossilization.", context: "Read Patten’s estimate in its original source and compare it with the fossil specimens and rapid-burial clues discussed throughout the archive.", assessment: "No modern experimental study is cited for the pressure estimate. Researchers study fossilization as a combination of burial, chemistry, and time; the figure remains a historical argument, not a measured fossil-forming mechanism.", references: [
        EvidenceReference(title: "Insight on the Scriptures · ‘Deluge’", kind: "BIBLICAL ENCYCLOPEDIA · ARGUMENT SOURCE", url: "https://www.jw.org/en/library/books/Insight-on-the-Scriptures/Deluge/"),
        EvidenceReference(title: "Patten · The Biblical Flood and the Ice Epoch (1966), p. 62", kind: "HISTORICAL FLOOD-GEOLOGY BOOK · CLAIM SOURCE", url: "https://books.google.com/books?id=wmJKAAAAIAAJ")
    ])
]

private let clues: [Clue] = [
    Clue(
        id: "scablands", title: "The Scablands Scar", place: "EASTERN WASHINGTON · NORTH AMERICA", symbol: "water.waves",
        category: "GEOLOGY · CONFIRMED ICE-AGE MEGAFLOODS",
        summary: "Basalt coulees, giant ripple marks, and gravel bars record immense outburst floods.",
        detail: "USGS research links the Channeled Scablands to repeated outburst floods from glacial Lake Missoula during the last Ice Age. These extraordinary floods reshaped a vast region. Could memories of a catastrophe on this scale have traveled far beyond the landscape where it happened?"
    ),
    Clue(
        id: "nuncho", title: "Nun cho ga", place: "YUKON · NORTH AMERICA", symbol: "pawprint.fill",
        category: "PALEONTOLOGY · PERMAFROST PRESERVATION",
        summary: "A remarkably preserved baby mammoth emerged from Yukon permafrost in 2022.",
        detail: "Nun cho ga is a near-complete mummified woolly mammoth calf found in Yukon in 2022, in Tr’ondëk Hwëch’in Traditional Territory. A quick examination suggested the calf was female; Yukon geologists estimated it died more than 30,000 years ago and was frozen in permafrost. Compare it with the Berezovka mammoth in the Siberian file: different animals, different places, both preserved in frozen ground. What can each specimen tell us about preservation—and what would require further evidence?"
    ),
    Clue(
        id: "ashfall", title: "The Ashfall Nursery", place: "NEBRASKA · NORTH AMERICA", symbol: "leaf",
        category: "FOSSIL SITE · VOLCANIC ASH",
        summary: "A Nebraska fossil bed preserves articulated animals in a layer of volcanic ash.",
        detail: "At Ashfall Fossil Beds, Nebraska, volcanic ash from an eruption in what is now southwestern Idaho fell over a watering hole about 11.93 million years ago. The ash bed preserves many articulated skeletons, including rhinos with unborn young. Compare this ashfall burial with the individual Chaohusaurus birth-position fossil from China: two very different snapshots, each with its own geological setting."
    ),
    Clue(
        id: "silt", title: "The Silt Line", place: "MESOPOTAMIA", symbol: "water.waves",
        category: "ARCHAEOLOGY · MESOPOTAMIA",
        summary: "At Lagash, a dated flood deposit more than a metre thick covered existing architecture.",
        detail: "A 2025 peer-reviewed study reports a flood-deposited silt layer more than a metre thick over architecture at Lagash (modern Tell al-Hiba), dated to the late Early Dynastic period, around 2400–2350 BCE. The authors propose that canal embankments may have been breached during conflict. Other Mesopotamian settlements preserve separate flood deposits from different periods. Compare the sites, dates, sediment, and historical context before linking any of them to a wider story."
    ),
    Clue(
        id: "tablet", title: "The Broken Tablet", place: "ANCIENT NEAR EAST", symbol: "scroll",
        category: "ANCIENT TEXT · CUNEIFORM",
        summary: "A flood survivor tells a story of a warning, a vessel, and a ruined world.",
        detail: "Mesopotamian flood narratives, including the Epic of Gilgamesh and Atrahasis, share themes with the Genesis account. The ancient versions share striking themes: a warning, a vessel, survival, and a changed world. Read the tablet record, then ask what catastrophe or memory could lie behind these accounts."
    ),
    Clue(
        id: "scripture", title: "The Biblical Record", place: "GENESIS & LATER BIBLE REFERENCES", symbol: "book.closed.fill",
        category: "SCRIPTURE · TEXTUAL TESTIMONY",
        summary: "Trace the Flood account from Genesis to later references in the Bible.",
        detail: "Genesis 6–9 recounts the Flood in Noah’s day, the Ark, the waters receding, and the covenant. Later Bible passages refer to Noah or the Flood for different scriptural purposes. Read each passage in context, then compare how the Biblical encyclopedia assembles them as testimony."
    ),
    Clue(
        id: "shore", title: "The Shifting Shore", place: "BLACK SEA",
        symbol: "water.waves.and.arrow.up", category: "GEOLOGY · ACTIVE DEBATE",
        summary: "A submerged ancient shoreline raises a difficult question: how quickly did the water rise?",
        detail: "Ryan and Pitman proposed that Mediterranean water broke through the Bosporus and rapidly entered a lower Black Sea basin. Submerged shorelines and changing sediments preserve a real environmental transition; how fast it happened, and what memories it left, remain questions for the investigator."
    )
]

private func challenge(for clueID: String) -> FieldChallenge {
    switch clueID {
    case "scablands":
        FieldChallenge(question: "In the glacial-lake deposits, what separates successive Missoula flood beds?", options: [
            ChallengeOption(id: "erratics", text: "Giant current ripples and transported boulders in a single flood deposit.", feedback: "These features show great flow power. A single deposit by itself does not establish how many floods passed through."),
            ChallengeOption(id: "varves", text: "Sequences of varves: fine lake sediments that accumulated between gravel or sand flood beds.", feedback: "Correct. The varves are lake deposits between floods; they record intervals between outbursts, not evidence that the landscape was exposed."),
            ChallengeOption(id: "channels", text: "A deep channel cut through basalt, with no sequence of flood deposits preserved.", feedback: "A channel records erosion and a route for water; the varve sequences are the evidence for intervals between repeated lake outbursts.")
        ], answerID: "varves", explanation: "Waitt describes gravel or sand beds emplaced by floods, separated by 20–55 varves in glacial-lake deposits. Varves are sediment layers, not dry-land exposure surfaces.", reasoningNote: "Read the deposit in its setting: the intervals accumulated in glacial lakes between outbursts." )
    case "nuncho":
        FieldChallenge(question: "Which observation does Nun cho ga preserve most directly?", options: [
            ChallengeOption(id: "berezovka", text: "Grasses recorded in the mouth and stomach of a mammoth from Siberia.", feedback: "That clue belongs to the separate Berezovka mammoth in the Smithsonian record, not to Nun cho ga."),
            ChallengeOption(id: "chaohusaurus", text: "A marine reptile fossil preserving a mother and young in a birth-position arrangement.", feedback: "That fossil is Chaohusaurus from China. It is a different specimen, place, and geological period."),
            ChallengeOption(id: "permafrost", text: "A near-complete mammoth calf with preserved tissue, recovered from Yukon permafrost.", feedback: "That is the direct specimen and find-context record for Nun cho ga.")
        ], answerID: "permafrost", explanation: "The Yukon discovery documents an unusually complete frozen mammoth calf. Its tissues and permafrost setting are direct observations; the wider burial story is reconstructed from additional clues.", reasoningNote: "A specimen is a time capsule. Its contents and surrounding ground are separate parts of the record." )
    case "ashfall":
        FieldChallenge(question: "What would help reconstruct how animals died at Ashfall?", options: [
            ChallengeOption(id: "species", text: "Use the number of species as a timeline for when each animal died.", feedback: "Species diversity describes the community, but the count alone does not establish the order or timing of deaths."),
            ChallengeOption(id: "sequence", text: "Compare which animals occur in lower and upper ash layers with evidence of lung damage.", feedback: "The layer sequence and bone pathology together help reconstruct the order and duration of deaths."),
            ChallengeOption(id: "waterhole", text: "Use the watering-hole setting alone to decide what killed the animals.", feedback: "The setting explains why animals gathered there. The ash layers and signs of lung damage provide evidence about cause and sequence.")
        ], answerID: "sequence", explanation: "Researchers use the vertical sequence of skeletons, preservation, and bone evidence to reconstruct a series of deaths during ashfall at the watering hole.", reasoningNote: "The bed preserves a sequence. Read the layers as well as the dramatic final scene." )
    case "silt":
        FieldChallenge(question: "How would an investigator compare flood deposits at two settlements?", options: [
            ChallengeOption(id: "surface", text: "Compare colour, thickness, and grain size before checking whether the dates agree.", feedback: "Physical similarity is useful for comparison, but matching appearance does not establish that two layers are the same age."),
            ChallengeOption(id: "texts", text: "Begin with a nearby flood story and use it to date the archaeological layer.", feedback: "Texts can add historical context; the layer itself needs archaeological and geological dating evidence."),
            ChallengeOption(id: "date", text: "Compare their independent dates, sediment signatures, and archaeological layers.", feedback: "Those independent site records let investigators test whether deposits could belong to the same episode.")
        ], answerID: "date", explanation: "Lagash’s layer is dated using several archaeological and geological clues. Similar deposits at other sites can be compared against that independent evidence.", reasoningNote: "Site-by-site dating lets you test whether separate traces belong to a shared episode." )
    case "tablet":
        FieldChallenge(question: "Two ancient flood accounts share a vessel and a survivor. What is the strongest next clue to examine?", options: [
            ChallengeOption(id: "compare", text: "Compare wording, event order, historical setting, dates, and possible transmission.", feedback: "That comparison weighs both the shared elements and differences while keeping the texts in historical context."),
            ChallengeOption(id: "motif", text: "Treat the shared vessel and survivor as proof that both texts describe the same event.", feedback: "Shared motifs invite comparison, but by themselves they do not establish identity of event or a route of transmission."),
            ChallengeOption(id: "setting", text: "Compare each account’s setting and distinctive details, without examining chronology.", feedback: "Setting and distinctive details matter; chronology is also needed to assess possible relationships between the texts.")
        ], answerID: "compare", explanation: "A careful comparison looks at shared and distinctive details, historical setting, chronology, and possible transmission. These clues help weigh whether the accounts are related.", reasoningNote: "The strongest connections account for both the parallels and the differences." )
    case "scripture":
        FieldChallenge(question: "How can you examine the Bible’s later references to Noah?", options: [
            ChallengeOption(id: "eyewitness", text: "Treat every later reference as a separate eyewitness account of the event.", feedback: "These are later scriptural references, not separate contemporaneous field reports. Read what each passage actually says."),
            ChallengeOption(id: "context", text: "Read each passage in context and compare what it says about Noah and the Flood.", feedback: "Reading the passages in context shows how the Bible’s later writers use Noah and the Flood in their own arguments."),
            ChallengeOption(id: "count", text: "Count the references and use the total to date the Flood.", feedback: "A count tells you how often the account is recalled; it does not give a date. Compare each reference’s content and context.")
        ], answerID: "context", explanation: "Genesis gives the main narrative; later passages refer to Noah and the Flood for different scriptural purposes. The Biblical encyclopedia presents those passages as testimony supporting the account.", reasoningNote: "Keep the Biblical text, the encyclopedia’s argument, and geological records identifiable as different kinds of evidence." )
    default:
        FieldChallenge(question: "Which record could best test the timing of a proposed Black Sea inflow?", options: [
            ChallengeOption(id: "shoreline", text: "Submerged shorelines mapped across the basin, with no dates for when they formed.", feedback: "Shorelines reveal former water levels and are valuable evidence; dating them is needed to test when the changes occurred."),
            ChallengeOption(id: "coast", text: "A modern coastline map used to infer the timing of the ancient change.", feedback: "A present-day map gives a reference for the basin, but it does not record the ancient environmental transition or its date."),
            ChallengeOption(id: "sediments", text: "Dated cores showing a transition from freshwater to marine conditions.", feedback: "Dated cores preserve both a sequence and environmental change, which can be used to constrain timing.")
        ], answerID: "sediments", explanation: "Researchers test the rapid-inflow proposal against dated sediment sequences, salinity changes, and submerged shorelines. Together, these records help constrain timing and scale.", reasoningNote: "Several independent traces from the basin make a stronger case than one striking clue." )
    }
}

private func record(for clueID: String) -> ClueRecord {
    switch clueID {
    case "scablands":
        ClueRecord(region: "washington", regionLabel: "Eastern Washington, USA", years: 14_000...20_000, periodLabel: "About 20,000–14,000 years ago", kind: "flood", kindLabel: "Physical flood record")
    case "nuncho":
        // Only a minimum age is published; the base of the Pleistocene caps the range so date comparisons stay conservative.
        ClueRecord(region: "yukon", regionLabel: "Klondike, Yukon, Canada", years: 30_000...2_580_000, periodLabel: "More than 30,000 years ago (preliminary estimate)", kind: "remains", kindLabel: "Preserved animal remains")
    case "ashfall":
        ClueRecord(region: "nebraska", regionLabel: "Northeastern Nebraska, USA", years: 11_800_000...12_100_000, periodLabel: "About 11.93 million years ago", kind: "remains", kindLabel: "Preserved animal remains")
    case "silt":
        ClueRecord(region: "mesopotamia", regionLabel: "Lagash, southern Mesopotamia (Iraq)", years: 4_370...4_430, periodLabel: "About 2400–2350 BCE", kind: "flood", kindLabel: "Physical flood record")
    case "tablet":
        ClueRecord(region: "mesopotamia", regionLabel: "Mesopotamia · cuneiform tablet", years: nil, periodLabel: "Written account · the tablet does not measure the event’s date", kind: "narrative", kindLabel: "Written flood account")
    case "scripture":
        ClueRecord(region: nil, regionLabel: "Biblical text · no excavated location", years: 4_395...4_395, periodLabel: "Biblical chronology in Insight: 2370 BCE · computed from the text, not a physical measurement", kind: "narrative", kindLabel: "Written flood account")
    default:
        ClueRecord(region: "blacksea", regionLabel: "Black Sea basin", years: 7_000...11_700, periodLabel: "Holocene · date proposed by Ryan and colleagues", kind: "flood", kindLabel: "Physical flood record")
    }
}

private func basisSupported(_ basis: String, firstID: String, secondID: String) -> Bool {
    let first = record(for: firstID), second = record(for: secondID)
    switch basis {
    case "same-region", "different-region":
        guard let a = first.region, let b = second.region else { return false }
        return (a == b) == (basis == "same-region")
    case "overlapping-dates", "different-dates":
        guard let a = first.years, let b = second.years else { return false }
        return a.overlaps(b) == (basis == "overlapping-dates")
    case "same-kind":
        return first.kind == second.kind
    default:
        return false
    }
}

private func isSupported(_ connection: CaseConnection) -> Bool {
    let allowed = connection.relation == "possible-link" ? linkBases : connection.relation == "different-records" ? differenceBases : []
    return allowed.contains(connection.basis) && basisSupported(connection.basis, firstID: connection.firstID, secondID: connection.secondID)
}

private func basisTitle(_ basis: String) -> String {
    switch basis {
    case "same-region": "SAME REGION"
    case "overlapping-dates": "DATES OVERLAP"
    case "same-kind": "SAME KIND OF RECORD"
    case "different-region": "DIFFERENT REGIONS"
    default: "DATES DO NOT OVERLAP"
    }
}

private func basisVerdict(_ basis: String, supported: Bool) -> String {
    switch (basis, supported) {
    case ("same-region", true): "Both records come from the same region. A shared region does not make them one event; compare their dates and deposits."
    case ("same-region", false): "The records do not share a location."
    case ("overlapping-dates", true): "The dates overlap. Check whether each date was measured or computed from a text; overlap alone does not make the records one event."
    case ("overlapping-dates", false): "The dates do not overlap, or one record has no date to compare."
    case ("same-kind", true): "Both are the same kind of record, so they can be compared directly. That alone does not make them one event."
    case ("same-kind", false): "These are different kinds of record; each answers a different question."
    case ("different-region", true): "Confirmed: the records come from different regions."
    case ("different-region", false): "Not confirmed: the records share a region, or one has no measured location."
    case ("different-dates", true): "Confirmed: the dates do not overlap."
    default: "Not confirmed: the dates overlap, or one record has no date to compare."
    }
}

private let romanianBibleBooks = [
    "genesis": "geneza", "psalms": "psalmii", "isaiah": "isaia", "ezekiel": "ezechiel", "matthew": "matei",
    "luke": "luca", "john": "ioan", "hebrews": "evrei", "1-peter": "1-petru", "2-peter": "2-petru"
]

// Watchtower Online Library document IDs of the Romanian Insight entries. The Romanian edition has no separate "Ark"
// entry, so it opens "Potopul din zilele lui Noe", which covers the ark's capacity.
private let romanianInsightEntries = ["Flood-of-Noahs-Day": "1200000758", "Deluge": "1200001150", "Noah": "1200003266", "Ark": "1200000758"]

private func romanianURL(for url: String) -> String? {
    let biblePrefix = "https://www.jw.org/en/library/bible/nwt/books/"
    if url.hasPrefix(biblePrefix) {
        let parts = url.dropFirst(biblePrefix.count).split(separator: "/").map(String.init)
        guard parts.count == 2, let book = romanianBibleBooks[parts[0]] else { return nil }
        return "https://www.jw.org/ro/biblioteca/biblia/nwt/carti/\(book)/\(parts[1])/"
    }
    let insightPrefix = "https://www.jw.org/en/library/books/Insight-on-the-Scriptures/"
    if url.hasPrefix(insightPrefix) {
        let entry = url.dropFirst(insightPrefix.count).split(separator: "/").map(String.init).first ?? ""
        guard let id = romanianInsightEntries[entry] else { return nil }
        return "https://wol.jw.org/ro/wol/d/r34/lp-m/\(id)"
    }
    return nil
}

private func references(for clueID: String) -> [EvidenceReference] {
    switch clueID {
    case "scablands": [
        EvidenceReference(title: "Waitt · Tens of successive, colossal Missoula floods", kind: "USGS FIELD REPORT · 1983", url: "https://pubs.usgs.gov/publication/ofr83671"),
        EvidenceReference(title: "USGS · Missoula and Bonneville floods review", kind: "GOVERNMENT GEOLOGY REVIEW", url: "https://www.usgs.gov/publications/missoula-and-bonneville-floods-a-review-ice-age-megafloods-columbia-river-basin"),
        EvidenceReference(title: "NASA Earth Observatory · Channeled Scablands imagery", kind: "SATELLITE IMAGERY & GEOLOGY", url: "https://science.nasa.gov/earth/earth-observatory/channeled-scablands-92025/")
    ]
    case "nuncho": [
        EvidenceReference(title: "Government of Yukon · Nun cho ga discovery", kind: "OFFICIAL DISCOVERY RELEASE", url: "https://yukon.ca/en/news/mummified-baby-woolly-mammoth-found-gold-miner-klondike"),
        EvidenceReference(title: "Yukon Geological Survey · 2022 overview", kind: "GOVERNMENT GEOLOGICAL RESEARCH", url: "https://open.yukon.ca/information/yukon-geological-survey-2022-overview"),
        EvidenceReference(title: "Smithsonian · Berezovka mammoth stomach contents", kind: "MUSEUM RESEARCH NOTE · SIBERIA", url: "https://www.si.edu/collections/snapshot/berezovka-woolly-mammoth-flesh-jar")
    ]
    case "ashfall": [
        EvidenceReference(title: "National Park Service · Ashfall paleontology and burial sequence", kind: "GOVERNMENT PALEONTOLOGY RESOURCE", url: "https://www.nps.gov/articles/000/paleontology-of-ashfall-fossil-beds-national-natural-landmark.htm"),
        EvidenceReference(title: "University of Nebraska · About Ashfall", kind: "MUSEUM GEOLOGY RESOURCE", url: "https://museum.unl.edu/ashfall/about-ashfall/"),
        EvidenceReference(title: "American Museum of Natural History · Ashfall fossils, including unborn young", kind: "MUSEUM PALEONTOLOGY RESOURCE", url: "https://research.amnh.org/paleontology/perissodactyl/evidence/findings/ashfall")
    ]
    case "silt": [
        EvidenceReference(title: "Goodman et al. · Flooding of Lagash, Iraq", kind: "PEER-REVIEWED GEOARCHAEOLOGY · 2025", url: "https://doi.org/10.1002/gea.70027"),
        EvidenceReference(title: "Jotheri et al. · Holocene rivers and Uruk", kind: "GEOARCHAEOLOGY RESEARCH", url: "https://discovery.ucl.ac.uk/id/eprint/10039203/"),
        EvidenceReference(title: "Woolley · Ur flood deposit in archaeological context", kind: "RESEARCH HISTORY & DISCUSSION", url: "https://doi.org/10.4236/ad.2015.31003")
    ]
    case "tablet": [
        EvidenceReference(title: "British Museum · Flood Tablet (K.2252)", kind: "PRIMARY ARTEFACT CATALOGUE", url: "https://www.britishmuseum.org/collection/object/W_K-2252"),
        EvidenceReference(title: "Genesis 6 · Noah commissioned to build the Ark", kind: "BIBLE TEXT · NEW WORLD TRANSLATION", url: "https://www.jw.org/en/library/bible/nwt/books/genesis/6/"),
        EvidenceReference(title: "Genesis 7 · The Flood begins", kind: "BIBLE TEXT · NEW WORLD TRANSLATION", url: "https://www.jw.org/en/library/bible/nwt/books/genesis/7/"),
        EvidenceReference(title: "Genesis 8 · The waters recede", kind: "BIBLE TEXT · NEW WORLD TRANSLATION", url: "https://www.jw.org/en/library/bible/nwt/books/genesis/8/"),
        EvidenceReference(title: "Genesis 9 · The covenant", kind: "BIBLE TEXT · NEW WORLD TRANSLATION", url: "https://www.jw.org/en/library/bible/nwt/books/genesis/9/"),
        EvidenceReference(title: "Oxford Academic · Precursors to Genesis flood narrative", kind: "SCHOLARLY BIBLICAL STUDIES · 2020", url: "https://doi.org/10.1093/oso/9780190062545.003.0007")
    ]
    case "scripture": [
        EvidenceReference(title: "Genesis 6 · Noah commissioned to build the Ark", kind: "NEW WORLD TRANSLATION · PRIMARY SCRIPTURAL TEXT", url: "https://www.jw.org/en/library/bible/nwt/books/genesis/6/"),
        EvidenceReference(title: "Genesis 7 · The Flood begins", kind: "NEW WORLD TRANSLATION · PRIMARY SCRIPTURAL TEXT", url: "https://www.jw.org/en/library/bible/nwt/books/genesis/7/"),
        EvidenceReference(title: "Genesis 8 · The waters recede", kind: "NEW WORLD TRANSLATION · PRIMARY SCRIPTURAL TEXT", url: "https://www.jw.org/en/library/bible/nwt/books/genesis/8/"),
        EvidenceReference(title: "Genesis 9 · The covenant", kind: "NEW WORLD TRANSLATION · PRIMARY SCRIPTURAL TEXT", url: "https://www.jw.org/en/library/bible/nwt/books/genesis/9/"),
        EvidenceReference(title: "Matthew 24 · Noah in Jesus’ warning", kind: "PRIMARY SCRIPTURAL TEXT", url: "https://www.jw.org/en/library/bible/nwt/books/matthew/24/"),
        EvidenceReference(title: "Luke 17 · The days of Noah", kind: "PRIMARY SCRIPTURAL TEXT", url: "https://www.jw.org/en/library/bible/nwt/books/luke/17/"),
        EvidenceReference(title: "Hebrews 11 · Noah’s faith", kind: "PRIMARY SCRIPTURAL TEXT", url: "https://www.jw.org/en/library/bible/nwt/books/hebrews/11/"),
        EvidenceReference(title: "1 Peter 3 · Noah and the Flood", kind: "PRIMARY SCRIPTURAL TEXT", url: "https://www.jw.org/en/library/bible/nwt/books/1-peter/3/"),
        EvidenceReference(title: "2 Peter 2 · Noah as a preacher", kind: "NEW WORLD TRANSLATION · PRIMARY SCRIPTURAL TEXT", url: "https://www.jw.org/en/library/bible/nwt/books/2-peter/2/"),
        EvidenceReference(title: "2 Peter 3 · The Flood account", kind: "NEW WORLD TRANSLATION · PRIMARY SCRIPTURAL TEXT", url: "https://www.jw.org/en/library/bible/nwt/books/2-peter/3/"),
        EvidenceReference(title: "Insight on the Scriptures · ‘Flood of Noah’s Day’", kind: "BIBLICAL ENCYCLOPEDIA · REPORTED ARGUMENT", url: "https://www.jw.org/en/library/books/Insight-on-the-Scriptures/Flood-of-Noahs-Day/"),
        EvidenceReference(title: "Insight on the Scriptures · ‘Noah’", kind: "BIBLICAL ENCYCLOPEDIA · REPORTED ARGUMENT", url: "https://www.jw.org/en/library/books/Insight-on-the-Scriptures/Noah/")
    ]
    case "shore": [
        EvidenceReference(title: "Ryan et al. · Black Sea flooding hypothesis", kind: "ORIGINAL RESEARCH · 1997", url: "https://doi.org/10.1016/S0025-3227(97)00007-8"),
    ]
    default: []
    }
}

private struct ArchiveView: View {
    @Environment(\.openURL) private var openURL
#if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
#endif
    @AppStorage("archiveLanguage") private var languageCode = "en"
    @AppStorage("archiveCurrentPage") private var storedPage = Page.briefing.rawValue
    @AppStorage("archiveCollectedClueIDs") private var storedCollectedClueIDs = ""
    @AppStorage("archiveTheory") private var storedTheory = ""
    @AppStorage("archiveTheoryNote") private var storedTheoryNote = ""
    @AppStorage("archiveTheoryConfidence") private var storedTheoryConfidence = 50.0
    @AppStorage("archiveTheoryFiled") private var theoryFiled = false
    @AppStorage("archiveChallengeAnswers") private var storedChallengeAnswers = ""
    // The key keeps its original name so progress saved by earlier builds survives.
    @AppStorage("archiveExaminedSourceClueIDs") private var storedOpenedSourceClueIDs = ""
    @AppStorage("archiveCaseConnections") private var storedCaseConnections = ""
    @AppStorage("archiveOpeningDismissed") private var openingDismissed = false
    @State private var selectedClue: String?
    @State private var expandedAuditID: String?
    @State private var embeddedUSGSPlayer: AVPlayer?
    @State private var isOptionalNoteOpen = false
    @State private var challengeDraft: String?
    @State private var challengeRevealedClueID: String?
    @State private var expandedSourceClueID: String?
    @State private var connectionFirst = "scablands"
    @State private var connectionSecond = "nuncho"
    @State private var connectionRelation = "possible-link"
    @State private var connectionBasis = ""
    @State private var isResetConfirmationShown = false

    private var page: Page {
        get { Page(rawValue: storedPage) ?? .briefing }
        nonmutating set { storedPage = newValue.rawValue }
    }

    private var collected: Set<String> {
        Set(storedCollectedClueIDs.split(separator: ",").map(String.init))
            .filter { challengeAnswers[$0] == challenge(for: $0).answerID }
    }

    private var challengeAnswers: [String: String] {
        guard let data = Data(base64Encoded: storedChallengeAnswers),
              let answers = try? JSONDecoder().decode([String: String].self, from: data) else { return [:] }
        return answers
    }

    private var solvedChallengeCount: Int {
        clues.filter { challengeAnswers[$0.id] == challenge(for: $0.id).answerID }.count
    }

    private var openedSourceClueIDs: Set<String> {
        Set(storedOpenedSourceClueIDs.split(separator: ",").map(String.init))
    }

    private var canFileTheory: Bool {
        collected.count >= 3 && distinctComparisonCount >= 2
    }

    private var distinctComparisonCount: Int {
        Set(caseConnections.filter(isSupported).map(\.pairID)).count
    }

    private var openQuestionCount: Int {
        caseConnections.filter { $0.relation == "needs-more" }.count
    }

    private var caseConnections: [CaseConnection] {
        storedCaseConnections.split(separator: ",").compactMap { item in
            let parts = item.split(separator: "~").map(String.init)
            guard parts.count >= 3 else { return nil }
            return CaseConnection(firstID: parts[0], secondID: parts[1], relation: parts[2], basis: parts.count > 3 ? parts[3] : "")
        }
    }

    private var pendingConnection: CaseConnection? {
        guard connectionFirst != connectionSecond else { return nil }
        let pair = [connectionFirst, connectionSecond].sorted()
        return CaseConnection(firstID: pair[0], secondID: pair[1], relation: connectionRelation, basis: connectionRelation == "needs-more" ? "" : connectionBasis)
    }

    private var canPinPendingConnection: Bool {
        guard let pending = pendingConnection, !caseConnections.contains(where: { $0.id == pending.id }) else { return false }
        return pending.relation == "needs-more" || !pending.basis.isEmpty
    }

    private var theoryNeedsExplanation: Bool {
        explainedTheories.contains(storedTheory)
    }

    private var hasTheoryExplanation: Bool {
        !storedTheoryNote.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private var availableConnectionClues: [Clue] {
        clues.filter { collected.contains($0.id) }
    }

    private var theory: String? {
        storedTheory.isEmpty ? nil : storedTheory
    }

    private func recordClue(_ id: String) {
        var ids = collected
        ids.insert(id)
        storedCollectedClueIDs = ids.sorted().joined(separator: ",")
    }

    private func saveChallengeAnswer(_ answerID: String, for clueID: String) {
        var answers = challengeAnswers
        answers[clueID] = answerID
        guard let data = try? JSONEncoder().encode(answers) else { return }
        storedChallengeAnswers = data.base64EncodedString()
    }

    private func markSourceOpened(for clueID: String) {
        var ids = openedSourceClueIDs
        ids.insert(clueID)
        storedOpenedSourceClueIDs = ids.sorted().joined(separator: ",")
    }

    private func saveCaseConnections(_ connections: [CaseConnection]) {
        storedCaseConnections = connections.map { "\($0.firstID)~\($0.secondID)~\($0.relation)~\($0.basis)" }.joined(separator: ",")
    }

    private func addCaseConnection() {
        guard canPinPendingConnection, let connection = pendingConnection else { return }
        saveCaseConnections(caseConnections + [connection])
    }

    private func findingText(_ connection: CaseConnection) -> String {
        if connection.relation == "needs-more" {
            return "Open question saved. It does not count until you record a finding the records support."
        }
        if connection.basis.isEmpty {
            return "Saved before findings needed a basis. Remove it and record the pair again to count it."
        }
        return basisVerdict(connection.basis, supported: isSupported(connection))
    }

    private func resetCase() {
        storedCollectedClueIDs = ""
        storedChallengeAnswers = ""
        storedOpenedSourceClueIDs = ""
        storedCaseConnections = ""
        storedTheory = ""
        storedTheoryNote = ""
        storedTheoryConfidence = 50
        theoryFiled = false
        UserDefaults.standard.removeObject(forKey: "archiveConnectionNotes")
        selectedClue = nil
        expandedAuditID = nil
        isOptionalNoteOpen = false
        challengeDraft = nil
        challengeRevealedClueID = nil
        expandedSourceClueID = nil
        connectionFirst = "scablands"
        connectionSecond = "nuncho"
        connectionRelation = "possible-link"
        connectionBasis = ""
        page = .briefing
        openingDismissed = false
    }

    private func prepareConnectionSelection() {
        let availableIDs = availableConnectionClues.map(\.id)
        guard availableIDs.count >= 2 else { return }

        if !availableIDs.contains(connectionFirst) {
            connectionFirst = availableIDs[0]
        }
        if !availableIDs.contains(connectionSecond) || connectionSecond == connectionFirst {
            connectionSecond = availableIDs.first(where: { $0 != connectionFirst }) ?? availableIDs[1]
        }
    }

    private func removeCaseConnection(_ connection: CaseConnection) {
        saveCaseConnections(caseConnections.filter { $0.id != connection.id })
    }

    private let ink = Color(red: 0.055, green: 0.075, blue: 0.09)
    private let panel = Color(red: 0.09, green: 0.12, blue: 0.135)
    private let gold = Color(red: 0.83, green: 0.66, blue: 0.39)
    private let sea = Color(red: 0.26, green: 0.58, blue: 0.61)

    var body: some View {
        appLayout
            .tint(gold)
            .confirmationDialog("Restart the case?", isPresented: $isResetConfirmationShown, titleVisibility: .visible) {
                Button("RESTART THE CASE", role: .destructive, action: resetCase)
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This clears cleared missions, challenge answers, opened sources, case-board findings, and your saved theory on this device. Your language choice is kept.")
            }
            .environment(\.locale, Locale(identifier: languageCode))
            .fullScreenModal(isPresented: Binding(
                get: { !openingDismissed },
                set: { if !$0 { openingDismissed = true } }
            )) {
                openingCard.environment(\.locale, Locale(identifier: languageCode))
            }
    }

    private let barColor = Color(red: 0.075, green: 0.095, blue: 0.108)

    private var contentPadding: CGFloat {
#if os(iOS)
        return horizontalSizeClass == .compact ? 16 : 32
#else
        return 32
#endif
    }

    // One layout on every device: section title on top, game sections in a bottom tab bar.
    private var appLayout: some View {
        VStack(spacing: 0) {
            topBar
            pageContent
                .padding(.horizontal, contentPadding).padding(.top, 18)
                .frame(maxWidth: 1120, maxHeight: .infinity, alignment: .topLeading)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            bottomTabBar
        }
        .background(ink.ignoresSafeArea())
    }

    private var topBar: some View {
        HStack(spacing: 8) {
            settingsMenu
            Spacer(minLength: 4)
            Text(LocalizedStringKey(page.rawValue))
                .font(.system(size: 17, weight: .semibold)).foregroundStyle(.white)
                .lineLimit(1)
            Spacer(minLength: 4)
            Text("\(collected.count)/\(clues.count)")
                .font(.system(size: 12, weight: .bold, design: .monospaced)).foregroundStyle(gold)
                .frame(width: 44, alignment: .trailing)
                .accessibilityLabel(Text("MISSIONS CLEARED \(collected.count)/\(clues.count)"))
        }
        .padding(.horizontal, 12)
        .frame(height: 50)
        .background(barColor.ignoresSafeArea(edges: .top))
        .overlay(alignment: .bottom) {
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Rectangle().fill(.white.opacity(0.08))
                    Rectangle().fill(gold).frame(width: geo.size.width * CGFloat(collected.count) / CGFloat(max(clues.count, 1)))
                }
            }
            .frame(height: 2)
        }
    }

    private var settingsMenu: some View {
        Menu {
            Section {
                Button { page = .briefing } label: {
                    Label(LocalizedStringKey(Page.briefing.rawValue), systemImage: Page.briefing.icon)
                }
            }
            Section("MISSIONS CLEARED \(collected.count)/\(clues.count)") {
                Picker("Language", selection: $languageCode) {
                    Text("English").tag("en")
                    Text("Română").tag("ro")
                }
                Button(role: .destructive) { isResetConfirmationShown = true } label: {
                    Label("RESTART THE CASE", systemImage: "arrow.counterclockwise")
                }
            }
        } label: {
            Image(systemName: "line.3.horizontal")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 44, height: 44)
                .contentShape(Rectangle())
        }
        .menuIndicator(.hidden)
#if os(macOS)
        .menuStyle(.borderlessButton)
        .fixedSize()
#endif
        .accessibilityLabel("Menu")
    }

    private var bottomTabBar: some View {
        HStack(spacing: 2) {
            ForEach(compactTabs) { item in
                let isActive = page == item
                Button { page = item } label: {
                    VStack(spacing: 4) {
                        Image(systemName: item.icon)
                            .font(.system(size: 17, weight: isActive ? .bold : .regular))
                            .frame(width: 46, height: 28)
                            .background(isActive ? gold.opacity(0.22) : .clear, in: Capsule())
                        Text(LocalizedStringKey(item.tabTitle))
                            .font(.system(size: 10, weight: isActive ? .bold : .medium))
                            .lineLimit(1).minimumScaleFactor(0.75)
                    }
                    .foregroundStyle(isActive ? gold : .white.opacity(0.5))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel(LocalizedStringKey(item.rawValue))
                .accessibilityAddTraits(isActive ? .isSelected : [])
            }
        }
        .frame(maxWidth: 720)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 6).padding(.top, 4)
        .background(barColor.ignoresSafeArea(edges: .bottom))
        .overlay(alignment: .top) { Rectangle().fill(.white.opacity(0.08)).frame(height: 1) }
    }

    @ViewBuilder private var pageContent: some View {
        switch page {
        case .briefing: briefingPage
        case .sites: sitesPage
        case .evidence: evidencePage
        case .northAmerica: northAmericaPage
        case .media: mediaPage
        case .claimAudit: claimAuditPage
        case .conclusion: conclusionPage
        }
    }

    private var briefingPage: some View {
      ScrollView {
        VStack(alignment: .leading, spacing: 26) {
            heroImage
            eyebrow("MISSION BRIEFING  /  01")
            Text("The water left\nmore than silence.")
                .font(.system(size: 48, weight: .regular, design: .serif)).tracking(-1.3).lineSpacing(-5)
            Text("A lost account. A buried city. A story that crossed generations. Follow the evidence behind the flood narrative—and decide what the traces can tell us.")
                .font(.system(size: 16)).foregroundStyle(.white.opacity(0.65)).lineSpacing(5).frame(maxWidth: 660, alignment: .leading)

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 14)], alignment: .leading, spacing: 14) {
                dossierStat(number: String(format: "%02d", clues.count), label: "MISSIONS TO CLEAR", icon: "point.topleft.down.to.point.bottomright.curvepath")
                dossierStat(number: "01", label: "ACTIVE INVESTIGATION", icon: "scope")
                dossierStat(number: "∞", label: "QUESTIONS", icon: "questionmark.circle")
            }.padding(.top, 3)

            Button { page = .sites } label: {
                HStack(spacing: 10) { Text("BEGIN INVESTIGATION"); Image(systemName: "arrow.right") }
                    .font(.system(size: 12, weight: .bold, design: .rounded)).tracking(1)
                    .padding(.horizontal, 19).padding(.vertical, 14)
                    .foregroundStyle(ink).background(gold, in: RoundedRectangle(cornerRadius: 8))
            }.buttonStyle(.plain).padding(.top, 8)

            Spacer(minLength: 5)
            HStack(spacing: 8) {
                Image(systemName: "quote.opening").foregroundStyle(sea)
                VStack(alignment: .leading, spacing: 3) {
                    Text("ORIGINAL INVESTIGATION MOTTO").font(.system(size: 8, weight: .semibold, design: .monospaced)).tracking(0.7).foregroundStyle(sea)
                    Text("The past is never buried as deep as it seems.")
                        .font(.system(size: 13, design: .serif)).italic().foregroundStyle(.white.opacity(0.55))
                }
            }
        }
      }
    }

    private var sitesPage: some View {
        ScrollView {
          VStack(alignment: .leading, spacing: 22) {
            eyebrow("EXPEDITION MAP  /  \(clues.count) ACTIVE MISSIONS")
            Text("Choose your next lead.").font(.system(size: 34, weight: .regular, design: .serif))
            Text("Each mission sends you to a real place, specimen, or historical record. Examine the evidence, then make your call.")
                .font(.system(size: 14)).foregroundStyle(.white.opacity(0.58))
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 245))], spacing: 15) {
                ForEach(clues) { clue in siteCard(clue) }
                if collected.count == clues.count { closingCard }
            }
            Spacer()
          }
        }
        .fullScreenModal(item: selectedClueBinding) { clue in clueSheet(clue) }
    }

    private func siteCard(_ clue: Clue) -> some View {
        let found = collected.contains(clue.id)
        let missionNumber = (clues.firstIndex(where: { $0.id == clue.id }) ?? 0) + 1
        return Button {
            selectedClue = clue.id
        } label: {
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Image(systemName: clue.symbol).font(.system(size: 19)).foregroundStyle(found ? sea : gold)
                        .frame(width: 43, height: 43).background((found ? sea : gold).opacity(0.12), in: RoundedRectangle(cornerRadius: 12))
                    Spacer()
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("MISSION \(String(format: "%02d", missionNumber))").font(.system(size: 8, weight: .bold, design: .monospaced)).foregroundStyle(gold.opacity(0.8))
                        Text(LocalizedStringKey(found ? "CLEARED" : "READY")).font(.system(size: 9, weight: .semibold, design: .monospaced)).tracking(0.8).foregroundStyle(found ? sea : .white.opacity(0.43))
                    }
                }
                VStack(alignment: .leading, spacing: 5) {
                    Text(LocalizedStringKey(clue.place)).font(.system(size: 9, weight: .medium, design: .monospaced)).tracking(1).foregroundStyle(.white.opacity(0.43))
                    Text(LocalizedStringKey(clue.title)).font(.system(size: 21, weight: .regular, design: .serif)).foregroundStyle(.white)
                    Text(LocalizedStringKey(clue.summary)).font(.system(size: 12)).foregroundStyle(.white.opacity(0.57)).lineSpacing(3).lineLimit(3)
                }
                HStack(spacing: 6) {
                    Text(LocalizedStringKey(found ? "REPLAY MISSION" : "START MISSION")).font(.system(size: 9, weight: .bold, design: .rounded)).tracking(0.8)
                    Image(systemName: "arrow.up.right").font(.system(size: 9, weight: .bold))
                }.foregroundStyle(gold).padding(.top, 2)
            }
            .padding(20).frame(maxWidth: .infinity, minHeight: 210, alignment: .leading)
            .background(panel, in: RoundedRectangle(cornerRadius: 15))
            .overlay(RoundedRectangle(cornerRadius: 15).stroke(found ? sea.opacity(0.22) : .white.opacity(0.06), lineWidth: 1))
        }.buttonStyle(.plain)
    }

    private var selectedClueBinding: Binding<Clue?> {
        Binding(get: { clues.first(where: { $0.id == selectedClue }) }, set: { selectedClue = $0?.id })
    }

    private func clueSheet(_ clue: Clue) -> some View {
      let missionNumber = (clues.firstIndex(where: { $0.id == clue.id }) ?? 0) + 1
      return VStack(spacing: 0) {
        HStack(spacing: 8) {
            Button { selectedClue = nil } label: {
                Image(systemName: "xmark").font(.system(size: 16, weight: .semibold)).foregroundStyle(.white)
                    .frame(width: 44, height: 44).contentShape(Rectangle())
            }
            .buttonStyle(.plain).accessibilityLabel("CLOSE")
            Spacer(minLength: 4)
            Text("MISSION \(String(format: "%02d", missionNumber))").font(.system(size: 15, weight: .semibold)).foregroundStyle(.white)
            Spacer(minLength: 4)
            Color.clear.frame(width: 44, height: 44)
        }
        .padding(.horizontal, 12)
        .frame(height: 50)
        .background(barColor.ignoresSafeArea(edges: .top))
        .overlay(alignment: .bottom) { Rectangle().fill(.white.opacity(0.08)).frame(height: 1) }
      ScrollView {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                Image(systemName: clue.symbol).font(.system(size: 20)).foregroundStyle(gold)
                Spacer()
                Text(LocalizedStringKey(clue.category)).font(.system(size: 9, weight: .semibold, design: .monospaced)).tracking(0.8).foregroundStyle(sea)
            }
            Text(LocalizedStringKey(clue.title)).font(.system(size: 30, weight: .regular, design: .serif))
            Text(LocalizedStringKey(clue.summary)).font(.system(size: 15, weight: .medium)).foregroundStyle(.white.opacity(0.78))
            Text(LocalizedStringKey(clue.detail)).font(.system(size: 13)).foregroundStyle(.white.opacity(0.64)).lineSpacing(5)
            clueIllustration(clue)
            DisclosureGroup(isExpanded: Binding(
                get: { expandedSourceClueID == clue.id },
                set: { expandedSourceClueID = $0 ? clue.id : nil }
            )) {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(references(for: clue.id)) { referenceLink($0, missionID: clue.id) }
                    if openedSourceClueIDs.contains(clue.id) {
                        Label("SOURCE OPENED · CHALLENGE UNLOCKED", systemImage: "checkmark.seal.fill")
                            .font(.system(size: 9, weight: .bold, design: .monospaced)).foregroundStyle(sea).padding(.top, 5)
                        Text("Opening a source only unlocks the challenge. The challenge checks what the record says.")
                            .font(.system(size: 10)).foregroundStyle(.white.opacity(0.5))
                    } else {
                        Text("Select a source above to open it and unlock the challenge.")
                            .font(.system(size: 10)).foregroundStyle(.white.opacity(0.5)).padding(.top, 5)
                    }
                }.padding(.top, 10)
            } label: {
                Label("SOURCE RECORDS · OPEN ONE TO UNLOCK THE CHALLENGE", systemImage: openedSourceClueIDs.contains(clue.id) ? "checkmark.seal.fill" : "doc.text.magnifyingglass")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundStyle(openedSourceClueIDs.contains(clue.id) ? sea : gold)
            }
            .tint(gold).padding(14).background(.white.opacity(0.035), in: RoundedRectangle(cornerRadius: 12))
            fieldChallengeCard(for: clue, sourceOpened: openedSourceClueIDs.contains(clue.id))
            let isSolved = challengeAnswers[clue.id] == challenge(for: clue.id).answerID
            let sourceOpened = openedSourceClueIDs.contains(clue.id)
            Button(LocalizedStringKey(collected.contains(clue.id) ? "MISSION CLEARED ✓" : !sourceOpened ? "OPEN A SOURCE RECORD FIRST" : isSolved ? "CLEAR THIS MISSION  →" : "SOLVE THE CHALLENGE FIRST")) {
                recordClue(clue.id); selectedClue = nil
            }
            .buttonStyle(.borderedProminent).tint(gold).foregroundStyle(ink)
            .disabled(collected.contains(clue.id) || !sourceOpened || !isSolved)
            .frame(maxWidth: .infinity, alignment: .trailing)
            HStack {
                Button("CLOSE") { selectedClue = nil }.buttonStyle(.plain).foregroundStyle(.white.opacity(0.6))
                Spacer()
                Text("SOURCE TRAIL PRESERVED").font(.system(size: 8, weight: .medium, design: .monospaced)).foregroundStyle(.white.opacity(0.4))
            }.padding(.top, 8)
        }
        .padding(.horizontal, contentPadding).padding(.vertical, 24)
        .frame(maxWidth: 760, alignment: .leading)
        .frame(maxWidth: .infinity)
        .onAppear {
            expandedSourceClueID = clue.id
            challengeDraft = challengeAnswers[clue.id]
            challengeRevealedClueID = challengeAnswers[clue.id] == nil ? nil : clue.id
        }
      }
      }
      .background(ink.ignoresSafeArea())
      .preferredColorScheme(.dark)
      .environment(\.locale, Locale(identifier: languageCode))
    }

    private func fieldChallengeCard(for clue: Clue, sourceOpened: Bool) -> some View {
        let fieldChallenge = challenge(for: clue.id)
        let savedAnswer = challengeAnswers[clue.id]
        let isSolved = savedAnswer == fieldChallenge.answerID
        let isRevealed = challengeRevealedClueID == clue.id, choice = fieldChallenge.options.first { $0.id == challengeDraft }
        return VStack(alignment: .leading, spacing: 13) {
            HStack {
                Label("FIELD CHALLENGE", systemImage: "scope").font(.system(size: 9, weight: .bold, design: .monospaced)).tracking(0.9).foregroundStyle(gold)
                Spacer()
                if isSolved { Label("CHALLENGE SOLVED", systemImage: "checkmark.circle.fill").font(.system(size: 8, weight: .bold, design: .monospaced)).foregroundStyle(sea) }
                else if savedAnswer != nil { Label("TRY AGAIN", systemImage: "arrow.counterclockwise").font(.system(size: 8, weight: .bold, design: .monospaced)).foregroundStyle(gold) }
            }
            Text(LocalizedStringKey(fieldChallenge.question)).font(.system(size: 19, design: .serif)).foregroundStyle(.white)
            if !sourceOpened {
                Label("Open a source record above to activate this evidence challenge.", systemImage: "lock.fill")
                    .font(.system(size: 11)).foregroundStyle(gold.opacity(0.9)).fixedSize(horizontal: false, vertical: true)
            }
            ForEach(fieldChallenge.options) { option in
                Button {
                    challengeDraft = option.id
                    challengeRevealedClueID = nil
                } label: {
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: challengeDraft == option.id ? "largecircle.fill.circle" : "circle")
                            .foregroundStyle(challengeDraft == option.id ? gold : .white.opacity(0.38)).padding(.top, 1)
                        Text(LocalizedStringKey(option.text)).font(.system(size: 12)).foregroundStyle(.white.opacity(0.82)).multilineTextAlignment(.leading)
                        Spacer(minLength: 0)
                    }.padding(12).background(challengeDraft == option.id ? gold.opacity(0.10) : .white.opacity(0.025), in: RoundedRectangle(cornerRadius: 10))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(challengeDraft == option.id ? gold.opacity(0.34) : .white.opacity(0.06), lineWidth: 1))
                }.buttonStyle(.plain).disabled(isSolved || !sourceOpened)
            }
            Button(LocalizedStringKey(!sourceOpened ? "OPEN A SOURCE TO BEGIN" : isSolved ? "CHALLENGE SOLVED ✓" : savedAnswer == nil ? "CHECK MY ANSWER  →" : "TRY AGAIN  →")) {
                guard let challengeDraft else { return }
                saveChallengeAnswer(challengeDraft, for: clue.id)
                challengeRevealedClueID = clue.id
            }
            .buttonStyle(.borderedProminent).tint(gold).foregroundStyle(ink).disabled(challengeDraft == nil || isSolved || !sourceOpened)
            if isRevealed, let choice {
                VStack(alignment: .leading, spacing: 9) {
                    Label(choice.id == fieldChallenge.answerID ? "YOU FOUND THE KEY DETAIL" : "HERE’S WHAT THE RECORD SHOWS", systemImage: choice.id == fieldChallenge.answerID ? "sparkle.magnifyingglass" : "text.magnifyingglass")
                        .font(.system(size: 8, weight: .bold, design: .monospaced)).tracking(0.8).foregroundStyle(sea)
                    Text(LocalizedStringKey(choice.feedback)).font(.system(size: 12, weight: .medium)).foregroundStyle(.white.opacity(0.86)).lineSpacing(3)
                    if choice.id == fieldChallenge.answerID {
                        Text(LocalizedStringKey(fieldChallenge.explanation)).font(.system(size: 12)).foregroundStyle(.white.opacity(0.78)).lineSpacing(3)
                    } else {
                        Text("Reread the source record, then choose again.").font(.system(size: 11, weight: .medium)).foregroundStyle(gold.opacity(0.9))
                    }
                    Text(LocalizedStringKey(fieldChallenge.reasoningNote)).font(.system(size: 11, design: .serif)).italic().foregroundStyle(gold.opacity(0.9)).lineSpacing(3)
                }.padding(14).background(sea.opacity(0.08), in: RoundedRectangle(cornerRadius: 11))
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
            Text("Open the source records first. Then compare your interpretation with the evidence.")
                .font(.system(size: 10)).foregroundStyle(.white.opacity(0.43)).lineSpacing(2)
        }
        .padding(16).background(panel, in: RoundedRectangle(cornerRadius: 14))
        .animation(.easeOut(duration: 0.24), value: challengeRevealedClueID)
    }

    private var evidencePage: some View {
      ScrollView {
        VStack(alignment: .leading, spacing: 22) {
            eyebrow("EVIDENCE WALL  /  MISSIONS CLEARED")
            Text("The clues, connected.").font(.system(size: 34, weight: .regular, design: .serif))
            Text("Every clue enters the archive with a source. Decide which traces belong together, and what kind of event could leave them behind.")
                .font(.system(size: 14)).foregroundStyle(.white.opacity(0.58)).frame(maxWidth: 740, alignment: .leading)
            if collected.isEmpty {
                emptyState(icon: "text.magnifyingglass", title: "No missions cleared yet", subtitle: "Start a mission to examine your first lead.", button: "GO TO MISSIONS") { page = .sites }
            } else {
                VStack(spacing: 11) {
                    ForEach(clues.filter { collected.contains($0.id) }) { clue in
                        HStack(alignment: .top, spacing: 15) {
                            Image(systemName: clue.symbol).font(.system(size: 17)).foregroundStyle(sea).frame(width: 39, height: 39).background(sea.opacity(0.12), in: RoundedRectangle(cornerRadius: 11))
                            VStack(alignment: .leading, spacing: 6) {
                                HStack { Text(LocalizedStringKey(clue.title)).font(.system(size: 17, design: .serif)); Spacer(); Text(LocalizedStringKey(clue.category)).font(.system(size: 8, weight: .medium, design: .monospaced)).foregroundStyle(gold.opacity(0.85)) }
                                Text(LocalizedStringKey(clue.detail)).font(.system(size: 12)).foregroundStyle(.white.opacity(0.59)).lineSpacing(3)
                            }
                        }.padding(16).background(panel, in: RoundedRectangle(cornerRadius: 12))
                    }
                }
                if collected.count >= 2 { caseBoard }
                HStack(spacing: 10) {
                    Image(systemName: "link").foregroundStyle(gold)
                    Text("Case question: which clues converge, and what might they reveal together?")
                        .font(.system(size: 12, design: .serif)).italic().foregroundStyle(.white.opacity(0.71))
                }.padding(16).background(gold.opacity(0.07), in: RoundedRectangle(cornerRadius: 11))
                Button("FORM YOUR THEORY  →") { page = .conclusion }.buttonStyle(.borderedProminent).tint(gold).foregroundStyle(ink).disabled(!canFileTheory)
                if collected.count < 3 {
                    Text("Clear three missions to unlock the final theory.").font(.system(size: 11)).foregroundStyle(.white.opacity(0.4))
                } else if distinctComparisonCount < 2 {
                    Text("Record supported findings for two different clue pairs on your case board before filing a theory.").font(.system(size: 11)).foregroundStyle(.white.opacity(0.4))
                }
            }
            Spacer()
        }
      }
    }

    private var caseBoard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Label("CASE BOARD", systemImage: "point.3.connected.trianglepath.dotted").font(.system(size: 9, weight: .bold, design: .monospaced)).tracking(0.9).foregroundStyle(gold)
                Spacer()
                HStack(spacing: 4) {
                    Text("\(distinctComparisonCount)")
                    Text("PAIRS WITH SUPPORTED FINDINGS")
                }.font(.system(size: 8, weight: .bold, design: .monospaced)).foregroundStyle(.white.opacity(0.45))
            }
            Text("Choose two cleared clues and a finding. A link or a difference needs a basis that the source records support; an open question is saved for later and does not count.")
                .font(.system(size: 13, design: .serif)).foregroundStyle(.white.opacity(0.68))
            HStack(spacing: 8) {
                clueMenu(selection: $connectionFirst)
                Image(systemName: "arrow.left.and.right").font(.system(size: 12, weight: .bold)).foregroundStyle(gold)
                clueMenu(selection: $connectionSecond)
            }
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 145), spacing: 8)], spacing: 8) {
                connectionRelationButton("possible-link", title: "MAY CONNECT", symbol: "link")
                connectionRelationButton("different-records", title: "DIFFERENT TIMES / PLACES", symbol: "point.topleft.down.to.point.bottomright.curvepath")
                connectionRelationButton("needs-more", title: "NEEDS MORE EVIDENCE", symbol: "questionmark.magnifyingglass")
            }
            if connectionRelation != "needs-more" {
                Text("BASIS FOR THIS FINDING").font(.system(size: 8, weight: .bold, design: .monospaced)).tracking(0.7).foregroundStyle(sea)
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 145), spacing: 8)], spacing: 8) {
                    ForEach(connectionRelation == "possible-link" ? linkBases : differenceBases, id: \.self) { basis in
                        basisButton(basis)
                    }
                }
            }
            pendingComparison
            Button {
                addCaseConnection()
            } label: {
                Label(LocalizedStringKey(connectionRelation == "needs-more" ? "SAVE OPEN QUESTION" : "ADD FINDING TO CASE BOARD"), systemImage: "pin.fill").font(.system(size: 9, weight: .bold, design: .monospaced)).tracking(0.6)
            }.buttonStyle(.borderedProminent).tint(gold).foregroundStyle(ink)
                .disabled(!canPinPendingConnection)
            if caseConnections.isEmpty {
                Text("Links are saved as working ideas. You can revise or remove them as you explore more clues.")
                    .font(.system(size: 10)).foregroundStyle(.white.opacity(0.43)).lineSpacing(3)
            } else {
                VStack(spacing: 8) {
                    ForEach(caseConnections) { connection in
                        VStack(alignment: .leading, spacing: 7) {
                            HStack(spacing: 8) {
                                Text(LocalizedStringKey(clueTitle(connection.firstID))).font(.system(size: 11, design: .serif)).lineLimit(1)
                                Image(systemName: "arrow.left.and.right").font(.system(size: 9)).foregroundStyle(gold)
                                Text(LocalizedStringKey(clueTitle(connection.secondID))).font(.system(size: 11, design: .serif)).lineLimit(1)
                                Spacer(minLength: 2)
                                Text(LocalizedStringKey(connectionTitle(connection.relation))).font(.system(size: 7, weight: .bold, design: .monospaced)).foregroundStyle(sea).multilineTextAlignment(.trailing)
                                Button { removeCaseConnection(connection) } label: {
                                    Image(systemName: "xmark.circle.fill").foregroundStyle(.white.opacity(0.4))
                                }.buttonStyle(.plain).accessibilityLabel("REMOVE CONNECTION")
                            }
                            if !connection.basis.isEmpty {
                                Text(LocalizedStringKey(basisTitle(connection.basis))).font(.system(size: 7, weight: .bold, design: .monospaced)).foregroundStyle(gold.opacity(0.85))
                            }
                            Label(LocalizedStringKey(findingText(connection)), systemImage: connection.relation == "needs-more" ? "questionmark.circle" : isSupported(connection) ? "checkmark.seal.fill" : "exclamationmark.triangle")
                                .font(.system(size: 10)).foregroundStyle(.white.opacity(0.55)).frame(maxWidth: .infinity, alignment: .leading)
                            if connection.relation != "needs-more" {
                                if !isSupported(connection) {
                                    Text("NOT SUPPORTED BY THE RECORDS · DOES NOT COUNT").font(.system(size: 7, weight: .bold, design: .monospaced)).foregroundStyle(gold)
                                }
                                recordSummary(connection.firstID)
                                recordSummary(connection.secondID)
                            }
                        }.padding(10).background(.white.opacity(0.035), in: RoundedRectangle(cornerRadius: 9))
                    }
                }
            }
        }
        .padding(16).background(panel, in: RoundedRectangle(cornerRadius: 14))
        .onAppear(perform: prepareConnectionSelection)
    }

    private func clueMenu(selection: Binding<String>) -> some View {
        Menu {
            ForEach(availableConnectionClues) { clue in
                Button(LocalizedStringKey(clue.title)) { selection.wrappedValue = clue.id }
            }
        } label: {
            HStack {
                Text(LocalizedStringKey(clueTitle(selection.wrappedValue))).font(.system(size: 11, weight: .medium, design: .serif)).lineLimit(1)
                Image(systemName: "chevron.down").font(.system(size: 8, weight: .bold))
            }.foregroundStyle(.white).frame(maxWidth: .infinity, alignment: .leading).padding(11)
                .background(.white.opacity(0.055), in: RoundedRectangle(cornerRadius: 9))
        }
    }

    private func connectionRelationButton(_ id: String, title: String, symbol: String) -> some View {
        Button {
            if connectionRelation != id { connectionBasis = "" }
            connectionRelation = id
        } label: {
            Label(LocalizedStringKey(title), systemImage: symbol).font(.system(size: 8, weight: .bold, design: .monospaced))
                .foregroundStyle(connectionRelation == id ? gold : .white.opacity(0.58))
                .frame(maxWidth: .infinity, minHeight: 35)
                .padding(.horizontal, 7).background(connectionRelation == id ? gold.opacity(0.10) : .white.opacity(0.025), in: RoundedRectangle(cornerRadius: 8))
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(connectionRelation == id ? gold.opacity(0.3) : .white.opacity(0.05), lineWidth: 1))
        }.buttonStyle(.plain)
    }

    private func basisButton(_ basis: String) -> some View {
        Button { connectionBasis = basis } label: {
            Text(LocalizedStringKey(basisTitle(basis))).font(.system(size: 8, weight: .bold, design: .monospaced))
                .foregroundStyle(connectionBasis == basis ? sea : .white.opacity(0.58))
                .frame(maxWidth: .infinity, minHeight: 31)
                .padding(.horizontal, 7).background(connectionBasis == basis ? sea.opacity(0.12) : .white.opacity(0.025), in: RoundedRectangle(cornerRadius: 8))
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(connectionBasis == basis ? sea.opacity(0.35) : .white.opacity(0.05), lineWidth: 1))
        }.buttonStyle(.plain)
    }

    @ViewBuilder private var pendingComparison: some View {
        if let pending = pendingConnection {
            VStack(alignment: .leading, spacing: 6) {
                if pending.relation == "needs-more" {
                    Text("An open question is saved for later. It does not count toward your theory.")
                        .font(.system(size: 11)).foregroundStyle(.white.opacity(0.62))
                } else if pending.basis.isEmpty {
                    Text("Choose the basis for this finding.")
                        .font(.system(size: 11)).foregroundStyle(gold.opacity(0.9))
                } else {
                    Text("Read both clues on the evidence wall first. The source records are checked when you pin the finding; only supported findings count.")
                        .font(.system(size: 11)).foregroundStyle(.white.opacity(0.62)).fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(12).frame(maxWidth: .infinity, alignment: .leading)
            .background(.white.opacity(0.03), in: RoundedRectangle(cornerRadius: 10))
        }
    }

    private func recordSummary(_ clueID: String) -> some View {
        let summary = record(for: clueID)
        return VStack(alignment: .leading, spacing: 2) {
            Text(LocalizedStringKey(clueTitle(clueID))).font(.system(size: 12, weight: .medium, design: .serif)).foregroundStyle(.white)
            (Text(LocalizedStringKey(summary.regionLabel)) + Text(" · ") + Text(LocalizedStringKey(summary.kindLabel)))
                .font(.system(size: 10)).foregroundStyle(.white.opacity(0.58))
            Text(LocalizedStringKey(summary.periodLabel)).font(.system(size: 10)).foregroundStyle(.white.opacity(0.58))
        }
    }

    private var accountForPanel: some View {
        VStack(alignment: .leading, spacing: 9) {
            Text("WHAT YOUR THEORY HAS TO ACCOUNT FOR").font(.system(size: 8, weight: .bold, design: .monospaced)).tracking(0.8).foregroundStyle(sea)
            ForEach(availableConnectionClues) { clue in
                let summary = record(for: clue.id)
                VStack(alignment: .leading, spacing: 2) {
                    Text(LocalizedStringKey(clue.title)).font(.system(size: 12, weight: .medium, design: .serif)).foregroundStyle(.white)
                    (Text(LocalizedStringKey(summary.regionLabel)) + Text(" · ") + Text(LocalizedStringKey(summary.periodLabel)))
                        .font(.system(size: 10)).foregroundStyle(.white.opacity(0.56))
                }
            }
            Text("Your case board: \(distinctComparisonCount) clue pairs with supported findings, \(openQuestionCount) open questions.")
                .font(.system(size: 10)).foregroundStyle(gold.opacity(0.85))
        }
        .padding(14).frame(maxWidth: 770, alignment: .leading)
        .background(.white.opacity(0.035), in: RoundedRectangle(cornerRadius: 11))
    }

    private func clueTitle(_ id: String) -> String {
        clues.first(where: { $0.id == id })?.title ?? id
    }

    private func connectionTitle(_ id: String) -> String {
        switch id {
        case "different-records": "DIFFERENT TIMES / PLACES"
        case "needs-more": "NEEDS MORE EVIDENCE"
        default: "MAY CONNECT"
        }
    }

    private var conclusionPage: some View {
      ScrollView {
        VStack(alignment: .leading, spacing: 22) {
            eyebrow("CASE REVIEW  /  YOUR INTERPRETATION")
            Text(LocalizedStringKey(theoryFiled ? "Theory entered into the archive." : "What is your working theory?"))
                .font(.system(size: 34, weight: .regular, design: .serif))
            Text("Lay the clues beside one another. Decide what your explanation accounts for, what it leaves unanswered, and how strongly you hold it.")
                .font(.system(size: 14)).foregroundStyle(.white.opacity(0.58)).lineSpacing(4).frame(maxWidth: 770, alignment: .leading)
            if !canFileTheory {
                if collected.count < 3 {
                    emptyState(icon: "lock", title: "The investigation is still unfolding", subtitle: "Clear three missions to unlock the final theory. More clues can be added later.", button: "RETURN TO MISSIONS") { page = .sites }
                } else {
                    emptyState(icon: "point.3.connected.trianglepath.dotted", title: "Connect the evidence", subtitle: "On the case board, record findings for two different clue pairs. Each finding needs a basis that the source records support; open questions are saved but do not count.", button: "OPEN THE CASE BOARD") { page = .evidence }
                }
            } else if theoryFiled, let theory {
                resultCard(theory)
            } else {
                VStack(alignment: .leading, spacing: 13) {
                    accountForPanel
                    Text("CHOOSE A WORKING POSITION · YOU CAN REVISE IT LATER").font(.system(size: 8, weight: .bold, design: .monospaced)).tracking(0.8).foregroundStyle(sea)
                    Group {
                        theoryOption("regional", title: "A great regional catastrophe began the story.", note: "One landscape, one disaster, remembered for generations.")
                        theoryOption("several", title: "Many disasters became one shared memory.", note: "Separate floods, carried together through ancient stories.")
                        theoryOption("noah", title: "Noah’s account preserves the memory of a real Flood.", note: "Explain how the geological and historical clues relate to Genesis.")
                        theoryOption("global", title: "One worldwide cataclysm connects the clues.", note: "Explain how clues from different places and periods fit one event.")
                        theoryOption("undecided", title: "The evidence is not enough for me to decide yet.", note: "Keep the investigation open; revisit your call after another mission.")
                        theoryOption("other", title: "I have another explanation.", note: "Describe it and the clues that support it.")
                    }
                    DisclosureGroup(LocalizedStringKey(theoryNeedsExplanation ? "EXPLAIN YOUR THEORY · REQUIRED" : "ADD AN OPTIONAL FIELD NOTE"), isExpanded: $isOptionalNoteOpen) {
                        VStack(alignment: .leading, spacing: 8) {
                            ZStack(alignment: .topLeading) {
                                if storedTheoryNote.isEmpty {
                                    Text(LocalizedStringKey(theoryNeedsExplanation ? "Explain how the clues’ places and periods fit your theory…" : "Optional: add a note about the clue that matters most to you…"))
                                        .font(.system(size: 12)).foregroundStyle(.white.opacity(0.32)).padding(.horizontal, 13).padding(.vertical, 15)
                                }
                                TextEditor(text: $storedTheoryNote).font(.system(size: 13)).scrollContentBackground(.hidden)
                                    .foregroundStyle(.white.opacity(0.88)).padding(7).accessibilityLabel("YOUR CASE REASONING")
                            }
                            .frame(height: 116).background(.white.opacity(0.045), in: RoundedRectangle(cornerRadius: 10))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(.white.opacity(0.08), lineWidth: 1))
                        }
                    }
                    .font(.system(size: 9, weight: .bold, design: .monospaced))
                    .tint(gold)
                    .padding(12).background(.white.opacity(0.035), in: RoundedRectangle(cornerRadius: 10))
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Text("HOW CONFIDENT ARE YOU?").font(.system(size: 8, weight: .bold, design: .monospaced)).tracking(0.7).foregroundStyle(sea)
                            Spacer()
                            Text("\(Int(storedTheoryConfidence))%").font(.system(size: 8, weight: .bold, design: .monospaced)).foregroundStyle(gold)
                            Text("YOUR ESTIMATE").font(.system(size: 8, weight: .bold, design: .monospaced)).foregroundStyle(gold)
                        }
                        Slider(value: $storedTheoryConfidence, in: 0...100, step: 5).tint(sea)
                        Text("Your confidence is a snapshot. Change it whenever a new clue shifts your view.").font(.system(size: 10)).foregroundStyle(.white.opacity(0.42))
                    }
                    Button {
                        theoryFiled = true
                    } label: {
                        Label("SAVE MY THEORY", systemImage: "tray.and.arrow.down.fill").font(.system(size: 10, weight: .bold, design: .monospaced)).tracking(0.7)
                    }.buttonStyle(.borderedProminent).tint(gold).foregroundStyle(ink)
                        .disabled(theory == nil || (theoryNeedsExplanation && !hasTheoryExplanation))
                    if theoryNeedsExplanation && !hasTheoryExplanation {
                        Text("This theory needs your explanation before it can be saved.")
                            .font(.system(size: 10, weight: .medium)).foregroundStyle(gold.opacity(0.9))
                    }
            Text("Your theory is saved. Replay missions and change your call whenever new evidence shifts your view.")
                        .font(.system(size: 10)).foregroundStyle(.white.opacity(0.42))
                }
            }
            Spacer()
        }
      }
    }

    @ViewBuilder private func clueIllustration(_ clue: Clue) -> some View {
        switch clue.id {
        case "scablands":
            ConceptDiagram(kind: "missoula", title: "One lake. Repeated regional floods.",
                analogy: "Imagine a plug holding back a bathtub: when it opens, water rushes out. Lake Missoula was vastly larger, and the real ice-dam mechanics were more complex.",
                note: "USGS research links the Scablands to repeated glacial-lake outbursts. The enormous flows make a striking comparison point for the other flood records in this archive.",
                steps: [
                    DiagramStep(title: "ICE DAM", detail: "A glacier blocks the river.", symbol: "snowflake"),
                    DiagramStep(title: "LAKE FILLS", detail: "Water builds behind the ice.", symbol: "water.waves"),
                    DiagramStep(title: "OUTBURST", detail: "Water races across the land.", symbol: "arrow.down.right"),
                    DiagramStep(title: "REPEATS", detail: "The lake refills; deposits remain.", symbol: "repeat")
                ])
        case "nuncho":
            ConceptDiagram(kind: "permafrost", title: "Permafrost: a natural freezer.",
                analogy: "Like a freezer, persistent cold slows decay. But preserved tissue alone cannot tell us exactly when, how, or how quickly an animal was buried.",
                note: "Nun cho ga was found in Yukon; Berezovka was found in Siberia. They are separate specimens from separate sites, not one shared event.",
                steps: [
                    DiagramStep(title: "REMAINS", detail: "An animal is buried in cold ground.", symbol: "pawprint.fill"),
                    DiagramStep(title: "FROZEN", detail: "Permafrost stays below freezing.", symbol: "snowflake"),
                    DiagramStep(title: "PRESERVED", detail: "Cold slows decomposition.", symbol: "leaf.fill"),
                    DiagramStep(title: "EXPOSED", detail: "Erosion or mining reveals it.", symbol: "magnifyingglass")
                ])
        case "ashfall":
            ConceptDiagram(kind: "ashfall", title: "From volcanic ash to fossil bed.",
                analogy: "Think of ash like a blanket settling over a landscape. At Ashfall, the deposit built up during a local event; the fossil bed preserves a sequence, not one instant frozen in time.",
                note: "The Nebraska State Museum describes a roughly 12-million-year-old volcanic-ash bed. Its burial history is distinct from water-laid flood deposits.",
                steps: [
                    DiagramStep(title: "ERUPTION", detail: "Volcanic ash rises in Idaho.", symbol: "smoke.fill"),
                    DiagramStep(title: "ASH DRIFTS", detail: "Winds carry fine ash east.", symbol: "wind"),
                    DiagramStep(title: "ANIMALS", detail: "Inhaled ash causes deaths over time.", symbol: "pawprint.fill"),
                    DiagramStep(title: "BURIAL", detail: "Ash and sediment preserve skeletons.", symbol: "square.stack.3d.up.fill")
                ])
        case "silt":
            ConceptDiagram(kind: "settlement", title: "A flood layer has a place and context.",
                analogy: "Think of each excavated layer as a page in one settlement’s diary. Another city’s similar-looking page needs its own date before the stories can be joined.",
                note: "Flood deposits at separate Mesopotamian sites need not be the same age or the same event. Archaeological context is essential.",
                steps: [
                    DiagramStep(title: "SETTLEMENT", detail: "People live beside a river.", symbol: "building.2.fill"),
                    DiagramStep(title: "DEPOSIT", detail: "Water leaves sediment at this site.", symbol: "water.waves"),
                    DiagramStep(title: "EXCAVATE", detail: "Archaeologists record its position.", symbol: "shovel.fill"),
                    DiagramStep(title: "COMPARE", detail: "Other sites are dated separately.", symbol: "arrow.left.arrow.right")
                ])
        case "tablet":
            ConceptDiagram(kind: "tablet", title: "Compare flood accounts, detail by detail.",
                analogy: "Two reports of a storm may both mention rain and rescue without being identical. Compare the wording, setting, date, and transmission before drawing a connection.",
                note: "Read Genesis beside Mesopotamian flood accounts. Shared details and distinctive features help investigators trace the history behind the stories.",
                steps: [
                    DiagramStep(title: "GENESIS", detail: "Read the account in context.", symbol: "book.closed.fill"),
                    DiagramStep(title: "TABLET", detail: "Examine the cuneiform record.", symbol: "scroll.fill"),
                    DiagramStep(title: "COMPARE", detail: "Mark shared and different details.", symbol: "arrow.left.arrow.right"),
                    DiagramStep(title: "INTERPRET", detail: "Weigh possible connections.", symbol: "text.magnifyingglass")
                ])
        case "scripture":
            ConceptDiagram(kind: "scripture", title: "Follow the account through the text.",
                analogy: "Think of later references as cross-links in a case file: each one recalls Noah for its own purpose. Read the surrounding passage to see exactly what it contributes.",
                note: "Genesis 6–9 contains the main narrative. Later passages are scriptural references, not separate geological observations or independent eyewitness reports.",
                steps: [
                    DiagramStep(title: "GENESIS", detail: "Read the Flood narrative in chapters 6–9.", symbol: "book.closed.fill"),
                    DiagramStep(title: "TRACE", detail: "Find later passages that mention Noah.", symbol: "magnifyingglass"),
                    DiagramStep(title: "CONTEXT", detail: "Read each passage around the reference.", symbol: "text.alignleft"),
                    DiagramStep(title: "COMPARE", detail: "Separate the text from the encyclopedia’s argument.", symbol: "arrow.left.arrow.right")
                ])
        case "shore":
            ConceptDiagram(kind: "blackSea", title: "The Black Sea rapid-inflow hypothesis.",
                analogy: "Picture water spilling over a low divider between two basins. The Bosporus proposal applies that idea to ancient shorelines and changing salinity; the rate and scale remain part of the hypothesis.",
                note: "Ryan and Pitman proposed that rapid Mediterranean inflow transformed the Black Sea basin. Compare their geological case with the other flood clues in the archive.",
                steps: [
                    DiagramStep(title: "BASIN", detail: "The Black Sea level is lower.", symbol: "water.waves"),
                    DiagramStep(title: "THRESHOLD", detail: "Water crosses the Bosporus sill.", symbol: "arrow.right"),
                    DiagramStep(title: "INFLOW", detail: "The basin receives seawater.", symbol: "water.waves.and.arrow.down"),
                    DiagramStep(title: "TEST", detail: "Study shorelines and sediments.", symbol: "magnifyingglass")
                ])
        default:
            EmptyView()
        }
    }

    private func theoryOption(_ id: String, title: String, note: String) -> some View {
        Button {
            storedTheory = id
            if explainedTheories.contains(id) { isOptionalNoteOpen = true }
        } label: {
            HStack(alignment: .top, spacing: 13) {
                Image(systemName: storedTheory == id ? "largecircle.fill.circle" : "circle").font(.system(size: 16)).foregroundStyle(storedTheory == id ? gold : .white.opacity(0.42)).padding(.top, 2)
                VStack(alignment: .leading, spacing: 5) {
                    Text(LocalizedStringKey(title)).font(.system(size: 15, weight: .medium)).foregroundStyle(.white)
                    Text(LocalizedStringKey(note)).font(.system(size: 11)).foregroundStyle(.white.opacity(0.5))
                }
                Spacer()
                Image(systemName: "arrow.right").foregroundStyle(gold.opacity(0.8))
            }.padding(15).background(storedTheory == id ? gold.opacity(0.08) : panel, in: RoundedRectangle(cornerRadius: 11))
                .overlay(RoundedRectangle(cornerRadius: 11).stroke(storedTheory == id ? gold.opacity(0.32) : .white.opacity(0.06), lineWidth: 1))
        }.buttonStyle(.plain)
    }

    @ViewBuilder private func resultCard(_ id: String) -> some View {
        let title: String = switch id {
        case "regional": "A regional disaster can become a world-changing story."
        case "several": "Many waters. Many memories. One enduring mystery."
        case "noah": "Your theory: Noah’s account preserves the memory of a real Flood."
        case "undecided": "You left the case open while the evidence is still incomplete."
        case "other": "Your explanation is on file. Keep testing it against the evidence."
        default: "Your theory: one worldwide cataclysm connects the clues."
        }
        let body: String = switch id {
        case "regional": "Your explanation of how one regional disaster could lie behind the story is saved below, beside the places, periods, and case-board findings it has to account for."
        case "several": "Your explanation of how separate floods could have merged into one shared memory is saved below, beside the places, periods, and case-board findings it has to account for."
        case "noah": "Your explanation of how the clues relate to the Genesis account is saved below, beside the places, periods, and case-board findings it has to account for."
        case "undecided": "You kept the case open while you examine more clues. Revisit your call after another mission or a new connection."
        case "other": storedTheoryNote
        default: "Your explanation of how clues from different places and periods fit one event is saved below, beside the case-board findings it has to account for."
        }
        VStack(alignment: .leading, spacing: 15) {
            HStack(spacing: 8) { Image(systemName: "archivebox.fill").foregroundStyle(sea); Text("FINAL THEORY SAVED").font(.system(size: 9, weight: .bold, design: .monospaced)).tracking(1).foregroundStyle(sea) }
            Text(LocalizedStringKey(title)).font(.system(size: 23, design: .serif))
            if id != "other" { Text(LocalizedStringKey(body)).font(.system(size: 13)).foregroundStyle(.white.opacity(0.65)).lineSpacing(4) }
            if hasTheoryExplanation {
                Text(LocalizedStringKey(explainedTheories.contains(id) ? "YOUR EXPLANATION" : "YOUR FIELD NOTE")).font(.system(size: 8, weight: .bold, design: .monospaced)).tracking(0.8).foregroundStyle(gold)
                Text(verbatim: storedTheoryNote).font(.system(size: 13)).foregroundStyle(.white.opacity(0.78)).lineSpacing(4)
            }
            accountForPanel
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("CURRENT CONFIDENCE").font(.system(size: 8, weight: .bold, design: .monospaced)).foregroundStyle(sea)
                    Spacer()
                    HStack(spacing: 4) {
                        Text("\(Int(storedTheoryConfidence))%")
                        Text("SELF-ESTIMATE")
                    }.font(.system(size: 8, weight: .bold, design: .monospaced)).foregroundStyle(gold)
                }
                ProgressView(value: storedTheoryConfidence, total: 100).tint(sea)
            }
            if !caseConnections.isEmpty {
                Text("FINDINGS YOU RECORDED").font(.system(size: 8, weight: .bold, design: .monospaced)).tracking(0.8).foregroundStyle(sea)
                ForEach(caseConnections) { connection in
                    VStack(alignment: .leading, spacing: 3) {
                        HStack(spacing: 5) {
                            Text(LocalizedStringKey(clueTitle(connection.firstID))).lineLimit(1)
                            Image(systemName: "arrow.left.and.right").font(.system(size: 8)).foregroundStyle(gold)
                            Text(LocalizedStringKey(clueTitle(connection.secondID))).lineLimit(1)
                            Text(LocalizedStringKey(connectionTitle(connection.relation))).font(.system(size: 7, weight: .bold, design: .monospaced)).foregroundStyle(sea)
                        }.font(.system(size: 10)).foregroundStyle(.white.opacity(0.70))
                        if !connection.basis.isEmpty {
                            Text(LocalizedStringKey(basisTitle(connection.basis))).font(.system(size: 7, weight: .bold, design: .monospaced)).foregroundStyle(gold.opacity(0.85))
                        }
                        Text(LocalizedStringKey(findingText(connection))).font(.system(size: 10)).foregroundStyle(.white.opacity(0.48))
                    }
                }
            }
            Divider().overlay(.white.opacity(0.1))
            Text("Your mission record keeps its sources, open questions, and revisions together. Your conclusion can change when your evidence changes.")
                .font(.system(size: 11)).foregroundStyle(.white.opacity(0.46)).lineSpacing(3)
            Button("EDIT MY THEORY") { theoryFiled = false }.buttonStyle(.plain).font(.system(size: 10, weight: .bold, design: .monospaced)).tracking(1).foregroundStyle(gold).padding(.top, 3)
        }.padding(22).background(panel, in: RoundedRectangle(cornerRadius: 14)).frame(maxWidth: 760, alignment: .leading)
    }

    private var closingCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: "sparkle.magnifyingglass").font(.system(size: 20)).foregroundStyle(gold)
            Text("The case is yours to close.").font(.system(size: 21, design: .serif))
            Text("You have \(clues.count) missions cleared. Connect the clues and choose your theory.").font(.system(size: 12)).foregroundStyle(.white.opacity(0.55))
            Button("REVIEW EVIDENCE  →") { page = .evidence }.buttonStyle(.plain).font(.system(size: 9, weight: .bold, design: .rounded)).tracking(0.8).foregroundStyle(gold)
        }.padding(20).frame(maxWidth: .infinity, minHeight: 210, alignment: .leading).background(gold.opacity(0.08), in: RoundedRectangle(cornerRadius: 15)).overlay(RoundedRectangle(cornerRadius: 15).stroke(gold.opacity(0.2), lineWidth: 1))
    }

    private func emptyState(icon: String, title: String, subtitle: String, button: String, action: @escaping () -> Void) -> some View {
        VStack(spacing: 12) {
            Image(systemName: icon).font(.system(size: 24)).foregroundStyle(gold)
            Text(LocalizedStringKey(title)).font(.system(size: 20, design: .serif))
            Text(LocalizedStringKey(subtitle)).font(.system(size: 12)).foregroundStyle(.white.opacity(0.55))
            Button(LocalizedStringKey(button), action: action).buttonStyle(.borderedProminent).tint(gold).foregroundStyle(ink).padding(.top, 5)
        }.frame(maxWidth: .infinity).padding(38).background(panel, in: RoundedRectangle(cornerRadius: 14)).padding(.top, 12)
    }

    private var openingCard: some View {
        VStack(alignment: .leading, spacing: 17) {
            HStack { Text("DOCUMENTED CASES · ORIGINAL SOURCES").font(.system(size: 9, weight: .bold, design: .monospaced)).tracking(1.0).foregroundStyle(gold); Spacer(); Image(systemName: "water.waves").foregroundStyle(sea) }
            Text("Flood stories. Traces in the ground.").font(.system(size: 26, design: .serif))
            Text("Follow \(clues.count) source-linked missions through real places, specimens, and texts, from Ice Age flood landscapes in North America to ancient flood accounts from Mesopotamia. Examine the observations, open the original references, then decide how the evidence fits together.")
                .font(.system(size: 13)).foregroundStyle(.white.opacity(0.63)).lineSpacing(4)
            Text("Your mission: follow the trail, uncover clues, and build the strongest case you can.")
                .font(.system(size: 12, weight: .medium)).foregroundStyle(.white.opacity(0.82)).lineSpacing(3)
            HStack { Spacer(); Button("OPEN THE CASE  →") { openingDismissed = true }.buttonStyle(.borderedProminent).tint(gold).foregroundStyle(ink) }
        }
        .padding(26).frame(maxWidth: 560)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ink.ignoresSafeArea())
        .preferredColorScheme(.dark)
    }

    private func dossierStat(number: String, label: String, icon: String) -> some View {
        VStack(alignment: .leading, spacing: 13) {
            Image(systemName: icon).font(.system(size: 15)).foregroundStyle(sea)
            Text(number).font(.system(size: 30, weight: .regular, design: .serif)).foregroundStyle(.white)
            Text(LocalizedStringKey(label)).font(.system(size: 9, weight: .medium, design: .monospaced)).tracking(0.8).foregroundStyle(.white.opacity(0.42))
        }.frame(maxWidth: .infinity, minHeight: 112, alignment: .leading).padding(.leading, 17).background(panel, in: RoundedRectangle(cornerRadius: 13))
    }

    private func eyebrow(_ text: LocalizedStringKey) -> some View {
        Text(text).font(.system(size: 9, weight: .semibold, design: .monospaced)).tracking(1.4).foregroundStyle(sea)
    }

    private var heroImage: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(colors: [Color(red: 0.08, green: 0.20, blue: 0.25), Color(red: 0.33, green: 0.28, blue: 0.20), Color(red: 0.09, green: 0.12, blue: 0.13)], startPoint: .topLeading, endPoint: .bottomTrailing)
            CanyonArt().stroke(Color.white.opacity(0.16), lineWidth: 1.4).padding(.horizontal, 28).padding(.top, 8)
            LinearGradient(colors: [.clear, ink.opacity(0.92)], startPoint: .center, endPoint: .bottom)
            VStack(alignment: .leading, spacing: 4) {
                Text("THE FLOOD ARCHIVE").font(.system(size: 10, weight: .bold, design: .monospaced)).tracking(2).foregroundStyle(gold)
                Text("A field investigation across continents").font(.system(size: 12, design: .serif)).foregroundStyle(.white.opacity(0.8))
            }.padding(18)
        }
        .frame(height: 205).clipShape(RoundedRectangle(cornerRadius: 17))
        .overlay(alignment: .topTrailing) { Text("ARTISTIC RECONSTRUCTION").font(.system(size: 8, weight: .medium, design: .monospaced)).tracking(0.7).foregroundStyle(.white.opacity(0.6)).padding(13) }
    }

    private var regionalMap: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack { eyebrow("NORTH AMERICAN FLOOD COUNTRY"); Spacer(); Text("ICE AGE").font(.system(size: 9, weight: .bold, design: .monospaced)).foregroundStyle(gold) }
            ZStack {
                RoundedRectangle(cornerRadius: 14).fill(LinearGradient(colors: [Color(red: 0.07, green: 0.16, blue: 0.19), Color(red: 0.12, green: 0.20, blue: 0.19)], startPoint: .top, endPoint: .bottom))
                MapShape().fill(Color(red: 0.25, green: 0.31, blue: 0.25).opacity(0.62)).padding(15)
                MapShape().stroke(Color(red: 0.70, green: 0.67, blue: 0.51).opacity(0.45), lineWidth: 1).padding(15)
                MapRiver().stroke(sea.opacity(0.9), style: StrokeStyle(lineWidth: 3, lineCap: .round, dash: [8,5])).padding(15)
                GeometryReader { geo in
                    mapPin("SCABLANDS").position(x: geo.size.width * 0.28, y: geo.size.height * 0.47)
                    mapPin("YUKON").position(x: geo.size.width * 0.32, y: geo.size.height * 0.19)
                    mapPin("NEBRASKA").position(x: geo.size.width * 0.53, y: geo.size.height * 0.63)
                }.padding(15)
            }.frame(maxWidth: .infinity).frame(height: 185).clipped()
            Text("Schematic map · plotted locations are approximate. Trace the North American cases and compare their flood records.").font(.system(size: 10)).foregroundStyle(.white.opacity(0.48))
        }.padding(17).background(panel, in: RoundedRectangle(cornerRadius: 17))
    }

    private func mapPin(_ label: String) -> some View {
        VStack(spacing: 3) { Circle().fill(gold).frame(width: 8, height: 8).overlay(Circle().stroke(ink, lineWidth: 2)); Text(LocalizedStringKey(label)).font(.system(size: 7, weight: .bold, design: .monospaced)).foregroundStyle(.white).fixedSize() }
    }

    private var northAmericaPage: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                eyebrow("FIELD MISSIONS  /  NORTH AMERICA")
                Text("A continent carved by water—and time.").font(.system(size: 34, weight: .regular, design: .serif))
                Text("Explore documented flood landscapes and exceptional fossil preservation. The map is schematic; each case is linked to its institutional source.").font(.system(size: 14)).foregroundStyle(.white.opacity(0.62)).lineSpacing(4)
                regionalMap
                photoCase(title: "The Channeled Scablands", subtitle: "Washington · repeated Ice Age outburst floods", url: "https://science.nasa.gov/earth/earth-observatory/channeled-scablands-92025/", image: "https://assets.science.nasa.gov/content/dam/science/esd/eo/images/imagerecords/92000/92025/potholescoulee_oli_2017245_lrg.jpg", source: "NASA Earth Observatory · USGS review")
                photoCase(title: "Nun cho ga", subtitle: "Yukon · a baby mammoth preserved in permafrost", url: "https://yukon.ca/en/news/mummified-baby-woolly-mammoth-found-gold-miner-klondike", image: nil, source: "Government of Yukon · photos at the source")
                photoCase(title: "Ashfall Fossil Beds", subtitle: "Nebraska · articulated fossils in volcanic ash", url: "https://museum.unl.edu/ashfall/ashfall-fossil-beds/", image: "https://museum.unl.edu/sites/unl.edu.nebraska-state-museum/files/styles/4_3_720x540/public/media/image/rhino_gallery_close_up.jpg?itok=tm_thQnJ", source: "University of Nebraska State Museum")
                Text("Cross-check: the grass-filled Berezovka mammoth was excavated in northeastern Siberia. The famous fossil of a marine reptile giving birth was discovered in China. Both are comparative clues, not North American finds.").font(.system(size: 12)).foregroundStyle(gold.opacity(0.9)).lineSpacing(4).padding(15).background(gold.opacity(0.07), in: RoundedRectangle(cornerRadius: 12))
            }.frame(maxWidth: 900, alignment: .leading)
        }
    }

    private var mediaPage: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                eyebrow("MISSION MEDIA  /  WATCH & EXAMINE")
                Text("Watch the flood story unfold.").font(.system(size: 34, weight: .regular, design: .serif))
                Text("Watch the USGS field lecture here, explore the Ashfall virtual tour, and open the original source whenever you want to check a detail.").font(.system(size: 14)).foregroundStyle(.white.opacity(0.58))
                embeddedVideoCard
                ashfallVideoCard
                mediaCard(title: "Ashfall Fossil Beds: 360° Virtual Tour", description: "Walk through the visitor centre and Rhino Barn with Nebraska Public Media.", source: "University of Nebraska State Museum · Nebraska Public Media", url: "https://nebraskapublicmedia.org/webxr/ashfallfossilbeds/", symbol: "view.3d")
                mediaCard(title: "Ashfall: Mysteries in the Dust", description: "Explore the Nebraska Studies story with archival NET Television footage and images from Ashfall.", source: "Nebraska Studies · Nebraska Public Media", url: "https://www.nebraskastudies.org/en/pre-1500/ashfall/", symbol: "play.rectangle.fill")
                mediaCard(title: "Berezovka: the Siberian mammoth", description: "Smithsonian account of the specimen and its stomach contents, including grasses.", source: "Smithsonian National Museum of Natural History", url: "https://www.si.edu/collections/snapshot/berezovka-woolly-mammoth-flesh-jar", symbol: "photo")
                timelineGraphic
                Text("The timeline places each clue beside its published age range. Compare traces from different places and periods.").font(.system(size: 10)).foregroundStyle(.white.opacity(0.45))
            }.frame(maxWidth: 900, alignment: .leading)
        }
    }

    private var embeddedVideoCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            Group {
                if let embeddedUSGSPlayer {
                    VideoPlayer(player: embeddedUSGSPlayer)
                        .accessibilityLabel("USGS lecture on the Great Missoula Floods")
                } else {
                    ZStack {
                        LinearGradient(colors: [panel, sea.opacity(0.35)], startPoint: .topLeading, endPoint: .bottomTrailing)
                        ProgressView("Loading USGS video…").tint(gold)
                    }
                }
            }
            .aspectRatio(16.0 / 9.0, contentMode: .fit)
            .onAppear {
                guard embeddedUSGSPlayer == nil,
                      let url = URL(string: "https://usgs-ocapsv2-public-output-media.s3.us-west-2.amazonaws.com/assets/palladium/production/s3fs-public/atoms/video/sep10/MP4/sep10.mp4") else { return }
                embeddedUSGSPlayer = AVPlayer(url: url)
            }
            .onDisappear { embeddedUSGSPlayer?.pause() }
            VStack(alignment: .leading, spacing: 7) {
                Text("The Great Missoula Floods").font(.system(size: 22, design: .serif))
                Text("Field lecture by USGS geologist Richard Waitt · 73 minutes").font(.system(size: 12)).foregroundStyle(.white.opacity(0.62))
                HStack {
                    Text("U.S. Geological Survey · Public Domain").font(.system(size: 9, design: .monospaced)).foregroundStyle(sea)
                    Spacer()
                    Link("SOURCE & TRANSCRIPT ↗", destination: URL(string: "https://www.usgs.gov/media/videos/pubtalk-92010-great-missoula-ice-age-floods-natl-geologic-trail")!)
                        .font(.system(size: 9, weight: .bold, design: .monospaced)).tint(gold)
                }
            }.padding(16)
        }.background(panel, in: RoundedRectangle(cornerRadius: 15)).clipShape(RoundedRectangle(cornerRadius: 15))
    }

    private var ashfallVideoCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let url = URL(string: "https://www.youtube-nocookie.com/embed/u5NlLnSG2fw?playsinline=1&rel=0") {
                InlineWebMedia(url: url).aspectRatio(16.0 / 9.0, contentMode: .fit)
            }
            VStack(alignment: .leading, spacing: 7) {
                Text("Ashfall Fossil Beds").font(.system(size: 22, design: .serif))
                Text("A visit to the fossil site with the University of Nebraska State Museum").font(.system(size: 12)).foregroundStyle(.white.opacity(0.62))
                HStack {
                    Text("University of Nebraska State Museum · embedded video").font(.system(size: 9, design: .monospaced)).foregroundStyle(sea)
                    Spacer()
                    Link("SOURCE VIDEO ↗", destination: URL(string: "https://www.youtube.com/watch?v=u5NlLnSG2fw")!)
                        .font(.system(size: 9, weight: .bold, design: .monospaced)).tint(gold)
                }
            }.padding(16)
        }.background(panel, in: RoundedRectangle(cornerRadius: 15)).clipShape(RoundedRectangle(cornerRadius: 15))
    }

    private var claimAuditPage: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                eyebrow("MISSION DEBRIEF  /  FLOOD ARGUMENTS & SOURCES")
                Text("Follow every claim to its source.").font(.system(size: 34, weight: .regular, design: .serif))
                Text("Compare documented observations with the Flood arguments presented in Insight on the Scriptures, a Biblical encyclopedia. Scientific, museum, and government references lead to the records behind each clue.")
                    .font(.system(size: 14)).foregroundStyle(.white.opacity(0.62)).lineSpacing(4).frame(maxWidth: 800, alignment: .leading)
                HStack(spacing: 8) {
                    Image(systemName: "info.circle.fill").foregroundStyle(gold)
                    Text("Source labels show whether a clue comes from scientific research, an institutional record, scripture, or a Biblical encyclopedia argument.")
                        .font(.system(size: 12, weight: .medium)).foregroundStyle(.white.opacity(0.76)).lineSpacing(3)
                }.padding(15).background(gold.opacity(0.08), in: RoundedRectangle(cornerRadius: 12))
                LazyVStack(spacing: 12) {
                    ForEach(auditFiles) { file in auditFileCard(file) }
                }
                mediaCard(title: "Take the claims into the field", description: "NASA satellite imagery of the Channeled Scablands, alongside the peer-reviewed flood review.", source: "NASA Earth Observatory · USGS", url: "https://science.nasa.gov/earth/earth-observatory/channeled-scablands-92025/", symbol: "globe.americas.fill")
            }.frame(maxWidth: 900, alignment: .leading)
        }
    }

    private func auditFileCard(_ file: AuditFile) -> some View {
        let isOpen = expandedAuditID == file.id
        return VStack(alignment: .leading, spacing: 0) {
            Button { expandedAuditID = isOpen ? nil : file.id } label: {
                HStack(alignment: .top, spacing: 13) {
                    Image(systemName: isOpen ? "chevron.down.circle.fill" : "circle.hexagongrid.fill")
                        .font(.system(size: 19)).foregroundStyle(gold).frame(width: 28)
                    VStack(alignment: .leading, spacing: 7) {
                        Text(LocalizedStringKey(file.label)).font(.system(size: 8, weight: .bold, design: .monospaced)).tracking(0.8).foregroundStyle(sea)
                        Text(LocalizedStringKey(file.title)).font(.system(size: 21, design: .serif)).foregroundStyle(.white)
                        Text(LocalizedStringKey(file.proClaim)).font(.system(size: 12)).foregroundStyle(.white.opacity(0.57)).lineSpacing(3).lineLimit(isOpen ? nil : 3)
                    }
                    Spacer(minLength: 0)
                }.padding(17).contentShape(Rectangle())
            }.buttonStyle(.plain)
            if isOpen {
                VStack(alignment: .leading, spacing: 14) {
                    auditParagraph("WHAT IS OBSERVED", text: file.observations, color: sea)
                    auditParagraph("THE ARGUMENT BUILT ON THESE CLUES", text: file.context, color: gold)
                    auditParagraph("WHAT THE CITED RESEARCH CONCLUDES", text: file.assessment, color: .white.opacity(0.75))
                    if file.id == "arkCapacity" { ArkProportionDiagram() }
                    VStack(alignment: .leading, spacing: 7) {
                        eyebrow("REFERENCES · OPEN THE SOURCE")
                        ForEach(file.references) { referenceLink($0) }
                    }.padding(.top, 2)
                }.padding(.horizontal, 17).padding(.bottom, 17)
            }
        }
        .background(panel, in: RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(isOpen ? gold.opacity(0.18) : .white.opacity(0.055), lineWidth: 1))
    }

    private func auditParagraph(_ heading: String, text: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(LocalizedStringKey(heading)).font(.system(size: 8, weight: .bold, design: .monospaced)).tracking(1).foregroundStyle(color)
            Text(LocalizedStringKey(text)).font(.system(size: 12)).foregroundStyle(.white.opacity(0.70)).lineSpacing(4)
        }
    }

    private func openReference(_ address: String, missionID: String?) {
        guard let url = URL(string: address) else { return }
        openURL(url) { accepted in
            if accepted, let missionID { markSourceOpened(for: missionID) }
        }
    }

    private func referenceLink(_ reference: EvidenceReference, missionID: String? = nil) -> some View {
        let romanian = romanianURL(for: reference.url)
        let primary = languageCode == "ro" ? (romanian ?? reference.url) : reference.url
        let alternate: (label: String, url: String)? = romanian.map { languageCode == "ro" ? (label: "EN ↗", url: reference.url) : (label: "RO ↗", url: $0) }
        return HStack(alignment: .top, spacing: 8) {
            Button {
                openReference(primary, missionID: missionID)
            } label: {
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "arrow.up.right.square").font(.system(size: 11)).foregroundStyle(gold).padding(.top, 1)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(LocalizedStringKey(reference.title)).font(.system(size: 11, weight: .medium)).foregroundStyle(.white.opacity(0.84))
                        Text(LocalizedStringKey(reference.kind)).font(.system(size: 8, weight: .medium, design: .monospaced)).tracking(0.45).foregroundStyle(sea)
                    }
                    Spacer(minLength: 0)
                }.contentShape(Rectangle())
            }.buttonStyle(.plain)
                .accessibilityHint("Opens the cited source in your browser.")
            if let alternate {
                Button {
                    openReference(alternate.url, missionID: missionID)
                } label: {
                    Text(verbatim: alternate.label).font(.system(size: 8, weight: .bold, design: .monospaced))
                        .foregroundStyle(gold).padding(.horizontal, 7).padding(.vertical, 4)
                        .background(gold.opacity(0.1), in: RoundedRectangle(cornerRadius: 6))
                }.buttonStyle(.plain)
                    .accessibilityLabel(LocalizedStringKey(languageCode == "ro" ? "English edition" : "Romanian edition"))
            }
        }
    }

    private func photoCase(title: String, subtitle: String, url: String, image: String?, source: String) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            AsyncImage(url: image.flatMap { URL(string: $0) }) { phase in
                if let img = phase.image { img.resizable().scaledToFill() }
                else { ZStack { LinearGradient(colors: [panel, sea.opacity(0.35)], startPoint: .topLeading, endPoint: .bottomTrailing); Image(systemName: "mountain.2.fill").font(.system(size: 42)).foregroundStyle(.white.opacity(0.35)) } }
            }.frame(height: 190).clipped()
            VStack(alignment: .leading, spacing: 6) {
                Text(LocalizedStringKey(title)).font(.system(size: 22, design: .serif))
                Text(LocalizedStringKey(subtitle)).font(.system(size: 12)).foregroundStyle(.white.opacity(0.6))
                HStack { Text(LocalizedStringKey(source)).font(.system(size: 9, design: .monospaced)).foregroundStyle(sea); Spacer(); Link("OPEN SOURCE ↗", destination: URL(string: url)!).font(.system(size: 9, weight: .bold, design: .monospaced)).tint(gold) }
                    .padding(.top, 5)
            }.padding(16)
        }.background(panel, in: RoundedRectangle(cornerRadius: 15)).clipShape(RoundedRectangle(cornerRadius: 15))
    }

    private func mediaCard(title: String, description: String, source: String, url: String, symbol: String) -> some View {
        Link(destination: URL(string: url)!) {
            HStack(spacing: 15) {
                ZStack { RoundedRectangle(cornerRadius: 12).fill(gold.opacity(0.13)); Image(systemName: symbol).font(.system(size: 20)).foregroundStyle(gold) }.frame(width: 54, height: 54)
                VStack(alignment: .leading, spacing: 5) { Text(LocalizedStringKey(title)).font(.system(size: 18, design: .serif)).foregroundStyle(.white); Text(LocalizedStringKey(description)).font(.system(size: 12)).foregroundStyle(.white.opacity(0.56)).lineSpacing(2); Text(LocalizedStringKey(source.uppercased())).font(.system(size: 8, weight: .medium, design: .monospaced)).tracking(0.7).foregroundStyle(sea).padding(.top, 3) }
                Spacer(); Image(systemName: "arrow.up.right").foregroundStyle(gold)
            }.padding(16).background(panel, in: RoundedRectangle(cornerRadius: 14))
        }.buttonStyle(.plain)
    }

    private var timelineGraphic: some View {
        VStack(alignment: .leading, spacing: 13) {
            eyebrow("EVIDENCE SPANS VERY DIFFERENT AGES")
            HStack(spacing: 10) {
                Image(systemName: "clock.fill").foregroundStyle(gold)
                VStack(alignment: .leading, spacing: 4) {
                    Text("~12 million years ago").font(.system(size: 12, weight: .semibold, design: .monospaced))
                    Text("Ashfall · Nebraska · volcanic ash fossil bed").font(.system(size: 11)).foregroundStyle(.white.opacity(0.58))
                }
            }
            Rectangle().fill(.white.opacity(0.12)).frame(height: 1)
            HStack(spacing: 10) {
                Image(systemName: "clock").foregroundStyle(sea)
                VStack(alignment: .leading, spacing: 4) {
                    Text("~30,000 to ~14,000 years ago").font(.system(size: 12, weight: .semibold, design: .monospaced))
                    Text("Nun cho ga · Yukon · preliminary estimate >30,000 years; Missoula floods · Washington · broad interval often given as ~20,000–14,000 years").font(.system(size: 11)).foregroundStyle(.white.opacity(0.58)).lineSpacing(3)
                }
            }
            Text("Not to scale. The Siberian Berezovka specimen is a comparison, not a North American site.").font(.system(size: 9)).foregroundStyle(gold.opacity(0.8))
        }.padding(18).background(panel, in: RoundedRectangle(cornerRadius: 15))
    }
}

private extension View {
    // Full-screen on iPhone and iPad, a large sheet on Mac, so screens look the same on every iOS device.
    @ViewBuilder func fullScreenModal<Content: View>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View {
#if os(iOS)
        fullScreenCover(isPresented: isPresented, content: content)
#else
        sheet(isPresented: isPresented) { content().frame(minWidth: 680, minHeight: 720) }
#endif
    }

    @ViewBuilder func fullScreenModal<Item: Identifiable, Content: View>(item: Binding<Item?>, @ViewBuilder content: @escaping (Item) -> Content) -> some View {
#if os(iOS)
        fullScreenCover(item: item, content: content)
#else
        sheet(item: item) { content($0).frame(minWidth: 680, minHeight: 720) }
#endif
    }
}

private struct DiagramStep: Identifiable {
    let title: String
    let detail: String
    let symbol: String
    var id: String { title }
}

#if os(iOS)
private struct InlineWebMedia: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        let view = WKWebView(frame: .zero, configuration: configuration)
        view.scrollView.isScrollEnabled = false
        view.load(URLRequest(url: url))
        return view
    }

    func updateUIView(_ view: WKWebView, context: Context) {}
}
#elseif os(macOS)
private struct InlineWebMedia: NSViewRepresentable {
    let url: URL

    func makeNSView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        let view = WKWebView(frame: .zero, configuration: configuration)
        view.load(URLRequest(url: url))
        return view
    }

    func updateNSView(_ view: WKWebView, context: Context) {}
}
#endif

private struct ConceptDiagram: View {
    let kind: String
    let title: String
    let analogy: String
    let note: String
    let steps: [DiagramStep]

    private let sea = Color(red: 0.31, green: 0.78, blue: 0.75)
    private let gold = Color(red: 0.89, green: 0.68, blue: 0.37)

    var body: some View {
        VStack(alignment: .leading, spacing: 13) {
            HStack {
                Text("VISUAL EXPLAINER").foregroundStyle(sea)
                Spacer()
                Text("SCHEMATIC · NOT TO SCALE").foregroundStyle(.white.opacity(0.42))
            }
            .font(.system(size: 8, weight: .bold, design: .monospaced)).tracking(0.6)
            Text(LocalizedStringKey(title)).font(.system(size: 21, design: .serif))
            DiagramArtwork(kind: kind, sea: sea, gold: gold).frame(height: 112)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], alignment: .leading, spacing: 10) {
                ForEach(Array(steps.enumerated()), id: \.element.id) { item in
                    let index = item.offset
                    let step = item.element
                    HStack(alignment: .top, spacing: 8) {
                        Text(String(format: "%02d", index + 1))
                            .font(.system(size: 9, weight: .bold, design: .monospaced)).foregroundStyle(gold)
                        VStack(alignment: .leading, spacing: 4) {
                            Label(LocalizedStringKey(step.title), systemImage: step.symbol)
                                .font(.system(size: 9, weight: .bold, design: .monospaced)).foregroundStyle(sea)
                            Text(LocalizedStringKey(step.detail)).font(.system(size: 10)).foregroundStyle(.white.opacity(0.7)).fixedSize(horizontal: false, vertical: true)
                        }
                    }.frame(maxWidth: .infinity, minHeight: 50, alignment: .topLeading)
                }
            }
            Text(LocalizedStringKey(analogy)).font(.system(size: 11, design: .serif)).italic().foregroundStyle(.white.opacity(0.78)).fixedSize(horizontal: false, vertical: true)
            Text(LocalizedStringKey(note)).font(.system(size: 10)).foregroundStyle(gold.opacity(0.86)).fixedSize(horizontal: false, vertical: true)
        }
        .padding(15)
        .background(Color.white.opacity(0.045), in: RoundedRectangle(cornerRadius: 13))
        .overlay(RoundedRectangle(cornerRadius: 13).stroke(.white.opacity(0.08), lineWidth: 1))
    }
}

private struct DiagramArtwork: View {
    let kind: String
    let sea: Color
    let gold: Color

    var body: some View {
        GeometryReader { proxy in
            let w = proxy.size.width
            let h = proxy.size.height
            ZStack {
                LinearGradient(colors: [Color(red: 0.08, green: 0.18, blue: 0.22), Color(red: 0.11, green: 0.14, blue: 0.18)], startPoint: .top, endPoint: .bottom)
                switch kind {
                case "missoula":
                    VStack(spacing: 0) {
                        Spacer()
                        Rectangle().fill(sea.opacity(0.42)).frame(height: h * 0.34)
                    }
                    HStack(alignment: .bottom, spacing: 0) {
                        Image(systemName: "mountain.2.fill").font(.system(size: 50)).foregroundStyle(gold.opacity(0.62))
                        Spacer(minLength: 20)
                        Rectangle().fill(Color.white.opacity(0.73)).frame(width: 18, height: h * 0.7)
                        Image(systemName: "mountain.2.fill").font(.system(size: 42)).foregroundStyle(gold.opacity(0.46)).scaleEffect(x: -1, y: 1)
                    }.padding(.horizontal, 18)
                    Image(systemName: "arrow.right").font(.system(size: 23, weight: .bold)).foregroundStyle(sea).position(x: w * 0.68, y: h * 0.72)
                case "permafrost":
                    VStack(spacing: 0) {
                        Rectangle().fill(Color.white.opacity(0.8)).frame(height: h * 0.18)
                        Rectangle().fill(Color(red: 0.25, green: 0.34, blue: 0.34).opacity(0.92))
                    }
                    Image(systemName: "pawprint.fill").font(.system(size: 40)).foregroundStyle(gold).position(x: w * 0.48, y: h * 0.68)
                    Image(systemName: "snowflake").font(.system(size: 26)).foregroundStyle(sea).position(x: w * 0.82, y: h * 0.35)
                case "ashfall":
                    VStack(spacing: 3) {
                        Rectangle().fill(gold.opacity(0.24)).frame(height: h * 0.26)
                        Rectangle().fill(Color(red: 0.69, green: 0.57, blue: 0.38)).frame(height: h * 0.27)
                        Rectangle().fill(Color(red: 0.26, green: 0.31, blue: 0.29)).frame(height: h * 0.38)
                    }.padding(.horizontal, 18).padding(.vertical, 6)
                    Image(systemName: "wind").font(.system(size: 30)).foregroundStyle(.white.opacity(0.7)).position(x: w * 0.26, y: h * 0.28)
                    Image(systemName: "pawprint.fill").font(.system(size: 24)).foregroundStyle(gold).position(x: w * 0.73, y: h * 0.7)
                case "settlement":
                    VStack(spacing: 2) {
                        Color(red: 0.25, green: 0.31, blue: 0.26).frame(height: h * 0.27)
                        gold.opacity(0.68).frame(height: h * 0.1)
                        Color(red: 0.35, green: 0.27, blue: 0.21).frame(height: h * 0.5)
                    }.padding(.horizontal, 15).padding(.vertical, 5)
                    Image(systemName: "building.2.fill").font(.system(size: 33)).foregroundStyle(.white.opacity(0.82)).position(x: w * 0.72, y: h * 0.24)
                    Image(systemName: "magnifyingglass").font(.system(size: 23, weight: .semibold)).foregroundStyle(sea).position(x: w * 0.34, y: h * 0.68)
                case "tablet":
                    HStack(spacing: 26) {
                        Image(systemName: "book.closed.fill").font(.system(size: 42)).foregroundStyle(gold)
                        Image(systemName: "arrow.left.arrow.right").font(.system(size: 22, weight: .semibold)).foregroundStyle(sea)
                        Image(systemName: "scroll.fill").font(.system(size: 42)).foregroundStyle(gold.opacity(0.76))
                    }
                case "scripture":
                    HStack(spacing: 22) {
                        Image(systemName: "book.closed.fill").font(.system(size: 42)).foregroundStyle(gold)
                        Image(systemName: "arrow.right").font(.system(size: 22, weight: .semibold)).foregroundStyle(sea)
                        Image(systemName: "text.book.closed.fill").font(.system(size: 42)).foregroundStyle(gold.opacity(0.76))
                    }
                default:
                    HStack(alignment: .bottom, spacing: 0) {
                        Rectangle().fill(sea.opacity(0.7)).frame(width: w * 0.43, height: h * 0.39)
                        Rectangle().fill(gold.opacity(0.55)).frame(width: w * 0.14, height: h * 0.55)
                        Rectangle().fill(sea.opacity(0.38)).frame(width: w * 0.43, height: h * 0.2)
                    }
                    Image(systemName: "arrow.right").font(.system(size: 23, weight: .bold)).foregroundStyle(.white).position(x: w * 0.56, y: h * 0.35)
                }
            }
        }
    }
}

private struct ArkProportionDiagram: View {
    private let sea = Color(red: 0.31, green: 0.78, blue: 0.75)

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("TEXTUAL DIAGRAM · GENESIS 6:15–16").font(.system(size: 8, weight: .bold, design: .monospaced)).tracking(0.6).foregroundStyle(sea)
            Text("Dimensions stated in the text: 300 × 50 × 30 cubits").font(.system(size: 13, weight: .semibold, design: .serif))
            Text("SIDE ELEVATION · 300 × 30").font(.system(size: 8, weight: .medium, design: .monospaced)).foregroundStyle(.white.opacity(0.55))
            RoundedRectangle(cornerRadius: 8).fill(Color(red: 0.55, green: 0.36, blue: 0.2).opacity(0.7))
                .overlay(VStack(spacing: 0) { Spacer(minLength: 0); Rectangle().fill(Color.white.opacity(0.26)).frame(height: 1); Spacer(minLength: 0); Rectangle().fill(Color.white.opacity(0.26)).frame(height: 1); Spacer(minLength: 0) }.padding(.vertical, 8))
                .frame(maxWidth: .infinity).frame(height: 32)
            Text("TOP PLAN · 300 × 50").font(.system(size: 8, weight: .medium, design: .monospaced)).foregroundStyle(.white.opacity(0.55))
            RoundedRectangle(cornerRadius: 5).fill(Color(red: 0.55, green: 0.36, blue: 0.2).opacity(0.48))
                .frame(maxWidth: .infinity).frame(height: 18)
            Text("A proportional diagram of the biblical description, not an archaeological reconstruction or evidence of a surviving vessel.")
                .font(.system(size: 10)).foregroundStyle(gold.opacity(0.86)).fixedSize(horizontal: false, vertical: true)
        }
        .padding(15).background(Color.white.opacity(0.045), in: RoundedRectangle(cornerRadius: 13))
    }

    private let gold = Color(red: 0.89, green: 0.68, blue: 0.37)
}

private struct CanyonArt: Shape {
    func path(in r: CGRect) -> Path {
        var p = Path()
        let w = r.width, h = r.height
        p.move(to: CGPoint(x: 0, y: h*0.78)); p.addLine(to: CGPoint(x: w*0.16, y: h*0.39)); p.addLine(to: CGPoint(x: w*0.26, y: h*0.59)); p.addLine(to: CGPoint(x: w*0.38, y: h*0.24)); p.addLine(to: CGPoint(x: w*0.50, y: h*0.62)); p.addLine(to: CGPoint(x: w*0.64, y: h*0.31)); p.addLine(to: CGPoint(x: w*0.75, y: h*0.56)); p.addLine(to: CGPoint(x: w*0.88, y: h*0.22)); p.addLine(to: CGPoint(x: w, y: h*0.48))
        p.move(to: CGPoint(x: 0, y: h*0.84)); p.addCurve(to: CGPoint(x: w, y: h*0.86), control1: CGPoint(x: w*0.30,y:h*0.75), control2: CGPoint(x: w*0.66,y:h*0.98))
        return p
    }
}

private struct MapShape: Shape {
    func path(in r: CGRect) -> Path {
        var p = Path(); let pts: [(CGFloat,CGFloat)] = [(0.08,0.21),(0.20,0.10),(0.36,0.14),(0.47,0.08),(0.60,0.15),(0.72,0.12),(0.83,0.25),(0.94,0.31),(0.91,0.45),(0.82,0.52),(0.85,0.66),(0.77,0.75),(0.69,0.85),(0.61,0.78),(0.53,0.67),(0.44,0.65),(0.39,0.53),(0.31,0.48),(0.25,0.39),(0.17,0.37),(0.13,0.28)]; p.move(to: CGPoint(x:r.width*pts[0].0,y:r.height*pts[0].1)); for q in pts.dropFirst(){p.addLine(to: CGPoint(x:r.width*q.0,y:r.height*q.1))}; p.closeSubpath(); return p
    }
}

private struct MapRiver: Shape {
    func path(in r: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: r.width*0.18, y: r.height*0.60))
        p.addCurve(to: CGPoint(x: r.width*0.50, y: r.height*0.40), control1: CGPoint(x: r.width*0.32, y: r.height*0.53), control2: CGPoint(x: r.width*0.31, y: r.height*0.34))
        p.addCurve(to: CGPoint(x: r.width*0.80, y: r.height*0.56), control1: CGPoint(x: r.width*0.66, y: r.height*0.47), control2: CGPoint(x: r.width*0.74, y: r.height*0.47))
        return p
    }
}
