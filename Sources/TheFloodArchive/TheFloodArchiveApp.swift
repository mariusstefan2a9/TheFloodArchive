import SwiftUI

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
        .windowStyle(.hiddenTitleBar)
        .defaultSize(width: 1180, height: 780)
#endif
    }
}

private enum Page: String, CaseIterable, Identifiable {
    case briefing = "Case File"
    case sites = "Expedition"
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
}

private struct Clue: Identifiable {
    let id: String
    let title: String
    let place: String
    let symbol: String
    let category: String
    let summary: String
    let detail: String
}

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
    let references: [EvidenceReference]
}

private let auditFiles: [AuditFile] = [
    AuditFile(id: "megafloods", title: "Megafloods: Missoula and Altai", label: "STRONG EVIDENCE · REGIONAL EVENTS", proClaim: "The pro-flood case starts with a sound observation: ordinary rivers cannot explain every landscape. The Missoula floods and Altai outburst floods were immense, fast, and geomorphically transformative.", observations: "Field mapping, giant current ripples, flood gravel, erratic boulders, and stacked flood beds document repeated glacial-lake outbursts. USGS synthesis estimates dozens, likely over a hundred, Missoula floods across roughly 20–14 thousand years ago. Altai lake drainage is a separate, independently studied regional megaflood system.", context: "These are excellent evidence that catastrophic regional floods happen. Their different basins, glacial dams, deposits, and ages do not combine into evidence for one simultaneous global flood or identify Noah’s event.", references: [
        EvidenceReference(title: "USGS · Missoula and Bonneville floods review", kind: "GOVERNMENT GEOLOGY REVIEW", url: "https://www.usgs.gov/publications/missoula-and-bonneville-floods-a-review-ice-age-megafloods-columbia-river-basin"),
        EvidenceReference(title: "Agatova et al. · Last ice-dammed lake in the Kuray basin", kind: "PEER-REVIEWED RESEARCH · 2020", url: "https://doi.org/10.1016/j.earscirev.2020.103183"),
        EvidenceReference(title: "Herget et al. · Altai megafloods—The temporal context", kind: "PEER-REVIEWED REVIEW · 2020", url: "https://doi.org/10.1016/j.earscirev.2019.102995"),
        EvidenceReference(title: "Rudoy · Altai glacial superfloods", kind: "PEER-REVIEWED RESEARCH · 2002", url: "https://doi.org/10.1016/S1040-6182(01)00066-0")
    ]),
    AuditFile(id: "blacksea", title: "Black Sea: a candidate flood", label: "RAPID-INFLOW HYPOTHESIS", proClaim: "Ryan and Pitman proposed that rising Mediterranean water breached the Bosporus and rapidly flooded a lower Black Sea basin in the early Holocene. They suggested the event could have affected farming communities and inspired flood traditions.", observations: "Submerged shorelines, marine and freshwater sediments, and changing salinity are documented in the Black Sea basin. Ryan and Pitman used geological and archaeological clues to argue for rapid inflow.", context: "This is a proposed regional event and one possible setting for ancient flood memories. The original paper presents its evidence and interpretation; the broader connection to Noah is an additional historical interpretation.", references: [
        EvidenceReference(title: "Ryan et al. · Catastrophic flooding of the Black Sea", kind: "ORIGINAL RESEARCH · 1997", url: "https://doi.org/10.1016/S0025-3227(97)00007-8"),
    ]),
    AuditFile(id: "seaLevel", title: "Drowned coasts after the Ice Age", label: "GLOBAL SEA-LEVEL RISE · SUBMERGED LANDSCAPES", proClaim: "After the Last Glacial Maximum, global sea level rose by roughly 120 metres as land ice melted. Former coastal plains and human landscapes were submerged; this could help explain why flood memories recur in coastal cultures.", observations: "Coral terraces, sediment cores, and dated shorelines record a large, multi-stage rise, including shorter meltwater pulses.", context: "The evidence includes submerged coastlines around the world. Flood researchers consider how memories of lost coastal landscapes may have travelled through generations; this cultural link is an interpretation built on the physical record.", references: [
        EvidenceReference(title: "Nature Geoscience · Barbados-based LGM ice-volume estimate", kind: "PEER-REVIEWED RESEARCH · 2013", url: "https://www.nature.com/articles/ngeo1859"),
        EvidenceReference(title: "Peltier · Last Glacial Maximum to Holocene sea-level history", kind: "PEER-REVIEWED REVIEW · 2002", url: "https://doi.org/10.1016/S0277-3791(01)00084-1"),
        EvidenceReference(title: "Rohling et al. · Extended Barbados sea-level record", kind: "PEER-REVIEWED RESEARCH · 2007", url: "https://doi.org/10.1016/j.quascirev.2006.12.004")
    ]),
    AuditFile(id: "marineFossils", title: "Marine fossils high above today’s sea", label: "OBSERVATION CONFIRMED · PROCESS EXPLAINED", proClaim: "Marine fossils occur high in the Himalayas, Alps, and Colorado Plateau. Flood advocates point to them as evidence that water once covered land now at great altitude.", observations: "Marine fossils really are found in elevated rock formations. At Grand Canyon, the Kaibab Limestone and other units preserve marine fossils and were deposited in ancient seas.", context: "A fossil’s present elevation is not the elevation at which it formed. The Colorado Plateau and mountain belts were uplifted by tectonic processes after marine sediments accumulated. The fossils support ancient marine environments and later uplift; they do not show that a recent global flood covered today’s mountains.", references: [
        EvidenceReference(title: "National Park Service · Grand Canyon fossils", kind: "PARK GEOLOGY RESOURCE", url: "https://www.nps.gov/grca/learn/nature/fossils.htm"),
        EvidenceReference(title: "National Park Service · Grand Canyon geology and uplift", kind: "PARK GEOLOGY RESOURCE", url: "https://www.nps.gov/grca/learn/nature/grca-geology.htm"),
        EvidenceReference(title: "National Park Service · Kaibab Formation", kind: "PARK GEOLOGY RESOURCE", url: "https://www.nps.gov/zion/learn/nature/kaibab.htm"),
        EvidenceReference(title: "ICR · Marine fossils on today’s mountain ranges", kind: "CREATIONIST-PERSPECTIVE INTERPRETATION", url: "https://www.icr.org/node/7444")
    ]),
    AuditFile(id: "megasequences", title: "Continental layers: Tapeats and Coconino", label: "REAL ROCKS · DEPOSITIONAL SETTING MATTERS", proClaim: "Flood geologists emphasize extensive sedimentary formations, large cross-beds, and paleocurrent directions. They argue that continent-scale water flows could deposit broad layers quickly.", observations: "Tapeats Sandstone is a broad Cambrian unit with documented marine, intertidal, and stream facies. The overlying Grand Canyon sequence includes distinct formations and trace fossils. The Coconino Sandstone is conventionally interpreted from its structures as wind-blown dune deposits; some creationist authors argue for subaqueous deposition.", context: "A formation can cover a large area without being deposited in one global event. Facies, fossils, sediment structures, source minerals, and dated layers help identify environments. In the Grand Canyon, the Tapeats belongs to a Cambrian transgression about 500 million years ago; the Coconino is Permian. A real debate about particular sedimentary features does not erase the broader stratigraphic and age evidence.", references: [
        EvidenceReference(title: "Hereford · Deposition of the Tapeats Sandstone", kind: "PEER-REVIEWED RESEARCH · GSA BULLETIN", url: "https://doi.org/10.1130/0016-7606%281977%2988%3C199%3ADOTTSC%3E2.0.CO%3B2"),
        EvidenceReference(title: "ICR · Global sedimentary sequences and megaflood interpretation", kind: "CREATIONIST-PERSPECTIVE RESEARCH", url: "https://www.icr.org/article/global-stratigraphy-supports-progressive"),
        EvidenceReference(title: "Whitmore & Garner · Coconino subaqueous interpretation", kind: "CREATIONIST-PERSPECTIVE CONFERENCE PAPER · 2023", url: "https://publications.cedarville.edu/icc_proceedings/vol_9_2023/588/")
    ]),
    AuditFile(id: "polystrate", title: "Upright trees and rapid burial", label: "POLYSTRATE FOSSILS · RAPID-BURIAL ARGUMENT", proClaim: "Some fossil trunks cross multiple beds. Flood proponents argue that sediment must have accumulated quickly enough to bury the standing trees before they decayed.", observations: "At Joggins, Nova Scotia, researchers documented fossil forests and plant–sediment structures in Pennsylvanian floodplain strata. The fossil forests record interactions between plants and sediment; creationist authors highlight upright trunks extending through several strata as evidence for rapid deposition.", context: "The flood interpretation treats polystrate trunks as snapshots of fast sedimentation during a large-scale catastrophe. Compare the fossil trunks, surrounding beds, and proposed mechanisms in the linked field and research sources.", references: [
        EvidenceReference(title: "Rygel, Gibling & Calder · Joggins fossil-forest sediment structures", kind: "PEER-REVIEWED RESEARCH · SEDIMENTOLOGY", url: "https://doi.org/10.1111/j.1365-3091.2004.00635.x"),
        EvidenceReference(title: "Joggins Fossil Cliffs · UNESCO World Heritage", kind: "INSTITUTIONAL SITE", url: "https://whc.unesco.org/en/list/1285/"),
        EvidenceReference(title: "ICR · Polystrate trees at Joggins Fossil Cliffs", kind: "CREATIONIST-PERSPECTIVE INTERPRETATION", url: "https://www.icr.org/article/445/")
    ]),
    AuditFile(id: "dinosaurTissue", title: "Dinosaur soft tissue and collagen", label: "UNUSUAL PRESERVATION · AGE IS INDEPENDENT", proClaim: "Researchers have reported flexible vessel-like structures, cell-shaped features, and protein signals in dinosaur fossils. Flood proponents argue that such preservation is difficult to reconcile with great age.", observations: "The structures and molecular signals are the subject of published laboratory studies. Schweitzer and colleagues proposed that iron and oxygen chemistry can slow degradation and help preserve or mask biomolecules; later work continues to test preservation mechanisms and identify what survives.", context: "‘Soft tissue’ does not mean a fresh dinosaur or intact blood. Exceptional molecular preservation is scientifically interesting, but it is not itself a clock and does not establish a young age or a flood. Fossil identity, stratigraphic position, and independent dating evidence are evaluated separately.", references: [
        EvidenceReference(title: "Schweitzer et al. · T. rex soft-tissue structures", kind: "SCIENCE · ORIGINAL RESEARCH · 2005", url: "https://doi.org/10.1126/science.1108397"),
        EvidenceReference(title: "Schweitzer et al. · Iron and deep-time preservation", kind: "PROCEEDINGS OF THE ROYAL SOCIETY B · 2014", url: "https://doi.org/10.1098/rspb.2013.2741"),
        EvidenceReference(title: "Wiemann et al. · Mechanisms of soft-tissue preservation", kind: "PEER-REVIEWED RESEARCH · 2019", url: "https://doi.org/10.1098/rsos.191972")
    ]),
    AuditFile(id: "unconformities", title: "Flat contacts and missing time", label: "WIDESPREAD LAYERS · RAPID-DEPOSITION ARGUMENT", proClaim: "Flood advocates point to broad, apparently flat contacts between rock units and argue that they could have been deposited in quick succession, without long gaps for erosion.", observations: "Grand Canyon formations include broad sedimentary layers and the Great Unconformity, a contact between ancient crystalline basement and younger sedimentary rock. The USGS describes unconformities as gaps caused by erosion and elapsed time before new deposition; creationist field reports emphasize the lateral continuity and relatively flat appearance of selected contacts.", context: "Flood geologists interpret extensive layers and selected flat contacts as products of successive, high-volume sediment flows during a major catastrophe. The linked field report presents that argument; the USGS source documents the contact and conventional geologic interpretation.", references: [
        EvidenceReference(title: "ICR · Grand Canyon: Exposing the Flood", kind: "CREATIONIST-PERSPECTIVE FIELD REPORT", url: "https://www.icr.org/node/18094"),
        EvidenceReference(title: "USGS · Stratified Rocks of the Grand Canyon", kind: "GOVERNMENT GEOLOGY MONOGRAPH", url: "https://pubs.usgs.gov/pp/0669/report.pdf"),
        EvidenceReference(title: "USGS · Geology of Grand Canyon National Park", kind: "GOVERNMENT GEOLOGY RESOURCE", url: "https://www.usgs.gov/geology-and-ecology-of-national-parks/geology-grand-canyon-national-park")
    ]),
    AuditFile(id: "folds", title: "Bent strata and the Kaibab fold", label: "FOLDING IS REAL · CAUSE REQUIRES STRUCTURAL EVIDENCE", proClaim: "Flood advocates cite sharply bent layers, including near the East Kaibab monocline, and argue that rock could bend without breaking only while sediment was still soft.", observations: "Soft-sediment deformation is real, but so are tectonic folds and faults. Structural studies of the East Kaibab monocline map faults through the fold and interpret it as fault-propagation folding during later regional compression.", context: "The claim that a whole sequence bent while uniformly soft is not established by the visual curve alone. Researchers map fractures, fault relationships, deformation across multiple strata, and timing indicators. Some local soft-sediment structures can coexist with much older and younger tectonic folding.", references: [
        EvidenceReference(title: "Tindall & Davis · East Kaibab monocline fault-propagation folding", kind: "PEER-REVIEWED STRUCTURAL GEOLOGY · 1999", url: "https://doi.org/10.1016/S0191-8141(99)00089-9"),
        EvidenceReference(title: "Snelling · Flood interpretation of Grand Canyon folds", kind: "CREATIONIST-PERSPECTIVE PAPER", url: "https://www.biblicalcreationtrust.org/pdf/e-origins_vol4_pp22-25_flood_geology_explains_grand_canyon_folds.pdf")
    ]),
    AuditFile(id: "cpt", title: "Catastrophic Plate Tectonics", label: "PROPOSED FLOOD MODEL · NOT MAINSTREAM CONSENSUS", proClaim: "John Baumgardner’s creationist model proposes runaway subduction, rapid movement of plates, seafloor volcanism, rising oceans, and intense rainfall during a Genesis Flood.", observations: "The model has been presented in the Proceedings of the International Conference on Creationism. Modern plate tectonics is strongly supported, but that does not automatically validate a rapid, year-long version of plate motion.", context: "A scientific model must match measured plate kinematics, geochemistry, heat flow, the thermal history of Earth, and geological chronology. Cite the specific model as its authors present it; do not label it as a result accepted by mainstream geophysics. The cited conference proceedings are a creationist venue, not a mainstream geoscience journal.", references: [
        EvidenceReference(title: "Baumgardner · Catastrophic Plate Tectonics: physics behind the model", kind: "CREATIONIST-PERSPECTIVE RESEARCH · 2003", url: "https://www.icr.org/article/catastrophic-plate-tectonics-flood"),
    ]),
    AuditFile(id: "rate", title: "RATE and helium in zircon", label: "PROPONENT CLAIM · METHOD-DEPENDENT INTERPRETATION", proClaim: "The RATE project reported helium retained in zircons from deep granite and argued that diffusion calculations imply a recent age and accelerated radioactive decay.", observations: "Helium diffusion in zircon is measurable and is used in thermochronology. Published research shows that diffusion behavior depends on temperature history, crystal properties, and radiation damage; those details matter when interpreting an age.", context: "The RATE interpretation is published in creationist research venues and is not accepted as evidence for accelerated nuclear decay by mainstream geochronology. A single helium-retention result cannot independently establish a six-thousand-year timescale; it must be tested against U–Pb ages, measured diffusion kinetics, and the full thermal history.", references: [
        EvidenceReference(title: "Humphreys · RATE zircon helium diffusion study", kind: "CREATIONIST-PERSPECTIVE RESEARCH · RATE II · 2005", url: "https://www.icr.org/node/8376"),
        EvidenceReference(title: "Guenthner et al. · Radiation damage and helium diffusion in zircon", kind: "PEER-REVIEWED THERMOCHRONOLOGY · 2013", url: "https://doi.org/10.2475/03.2013.01"),
        EvidenceReference(title: "Guenthner et al. · Zircon damage-annealing model", kind: "PEER-REVIEWED RESEARCH · 2021", url: "https://doi.org/10.1029/2019GC008757"),
    ]),
    AuditFile(id: "fossilOrder", title: "Fossil order and radiometric ages", label: "MULTIPLE INDEPENDENT LINES OF EVIDENCE", proClaim: "Flood proponents suggest ecological zonation, mobility, habitat, and water transport could influence which organisms were buried first, so fossil order deserves investigation rather than a slogan.", observations: "Across many regions, fossil assemblages occur in a reproducible succession. Radiometric ages from suitable igneous minerals bracket sedimentary strata; fossil succession and isotope dating are related but distinct methods.", context: "A flood model can be compared with the observed fossil order and with independently dated layers. The references below explain both the pro-flood proposal and the methods used to build and cross-check geological sequences.", references: [
        EvidenceReference(title: "ICR · The five rules of Flood paleontology", kind: "CREATIONIST-PERSPECTIVE RESEARCH", url: "https://www.icr.org/article/13444/"),
        EvidenceReference(title: "Smithsonian · Stratigraphy, fossil succession, and dating", kind: "MUSEUM SCIENCE RESOURCE", url: "https://humanorigins.si.edu/evidence/dating"),
        EvidenceReference(title: "International Commission on Stratigraphy · Geologic time scale", kind: "INTERNATIONAL SCIENTIFIC STANDARD", url: "https://stratigraphy.org/" )
    ]),
    AuditFile(id: "birthFossil", title: "A fossil caught giving birth", label: "EXCEPTIONAL FOSSIL · CHINA, NOT NORTH AMERICA", proClaim: "A Chaohusaurus fossil preserves a mother, two embryos, and a neonate in a birth-position arrangement. Flood advocates point to such snapshots as evidence that organisms could be buried suddenly during catastrophe.", observations: "The authors report three associated young: one inside the mother, one partly emerging, and one outside. They conclude that the mother likely died in labor; they also note that the rock is marine and infer that birth most likely occurred underwater.", context: "The specimen comes from China and dates to the Early Triassic, around 248 million years ago. It is a remarkable snapshot of preservation. The paper documents the fossil and the authors’ interpretation; the broader link to Noah’s Flood is a separate inference.", references: [
        EvidenceReference(title: "Motani et al. · Chaohusaurus embryos and birth position", kind: "PEER-REVIEWED RESEARCH · PLOS ONE · 2014", url: "https://doi.org/10.1371/journal.pone.0088640"),
        EvidenceReference(title: "PLOS ONE · Full article and figures", kind: "OPEN-ACCESS ORIGINAL PAPER", url: "https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0088640")
    ]),
    AuditFile(id: "grassMammoth", title: "The mammoth with grass in its mouth", label: "BEREZOVKA · SIBERIA · RAPID-PRESERVATION CLUE", proClaim: "The Berezovka mammoth was found with vegetation in its mouth and plant material in its stomach. Flood advocates cite this preserved final meal as a striking snapshot of an animal overcome and rapidly buried.", observations: "The Smithsonian documents grasses and other plants in the mammoth’s stomach. Pfizenmayer’s expedition account also describes vegetation preserved in the mouth. The specimen was recovered from Siberian permafrost, which preserved soft tissue and plant material.", context: "This is one exceptionally preserved Siberian mammoth. The last meal is directly documented; the cause and speed of burial are interpreted from the carcass and its geological setting. Flood proponents connect the case to a larger catastrophe.", references: [
        EvidenceReference(title: "Smithsonian · Berezovka woolly mammoth and stomach contents", kind: "MUSEUM RESEARCH NOTE", url: "https://www.si.edu/collections/snapshot/berezovka-woolly-mammoth-flesh-jar"),
        EvidenceReference(title: "Pfizenmayer · Siberian mammoths and the Berezovka expedition", kind: "HISTORICAL EXPEDITION ACCOUNT · 1939", url: "https://rcin.org.pl/dlibra/publication/3640/edition/3278/les-mammouths-de-siberie-le-decouverte-de-cadavres-de-mammouths-prehistoriques-sur-les-bords-de-la-berezovka-et-de-la-sanga-iourakh-pfizenmayer-eugen-wilhelm-1869-1941?language=pl"),
        EvidenceReference(title: "ICR · Mammoths and rapid burial in the Flood model", kind: "CREATIONIST-PERSPECTIVE INTERPRETATION", url: "https://www.icr.org/article/mammoths-testify-flood")
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
        detail: "Nun cho ga is a female woolly mammoth calf found in Yukon in 2022, in Tr’ondëk Hwëch’in traditional territory. The find is an extraordinary example of permafrost preservation. Compare it with the Berezovka mammoth in the Siberian file: different animals, different places, both preserved in frozen ground. What burial conditions can preserve a whole carcass?"
    ),
    Clue(
        id: "ashfall", title: "The Ashfall Nursery", place: "NEBRASKA · NORTH AMERICA", symbol: "leaf",
        category: "FOSSIL SITE · VOLCANIC ASH",
        summary: "A Nebraska fossil bed preserves articulated animals in a layer of volcanic ash.",
        detail: "At Ashfall Fossil Beds, Nebraska, the University of Nebraska State Museum describes a Miocene assemblage buried by volcanic ash from an eruption in what is now Idaho. The site preserves articulated skeletons and pregnant animals. Compare this mass burial with the individual Chaohusaurus birth-position fossil from China: two very different snapshots of life interrupted."
    ),
    Clue(
        id: "silt", title: "The Silt Line", place: "MESOPOTAMIA", symbol: "water.waves",
        category: "ARCHAEOLOGY · MESOPOTAMIA",
        summary: "A band of water-laid clay cuts through the remains of an ancient settlement.",
        detail: "Excavations at several Mesopotamian cities found flood deposits. Each layer belongs to the story of its own settlement; together they show how water repeatedly reshaped the region where some of the oldest flood narratives took form. Compare the sites, dates, and stories."
    ),
    Clue(
        id: "tablet", title: "The Broken Tablet", place: "ANCIENT NEAR EAST", symbol: "scroll",
        category: "ANCIENT TEXT · CUNEIFORM",
        summary: "A flood survivor tells a story of a warning, a vessel, and a ruined world.",
        detail: "Mesopotamian flood narratives, including the Epic of Gilgamesh and Atrahasis, share themes with the Genesis account. The ancient versions share striking themes: a warning, a vessel, survival, and a changed world. Read the tablet record, then ask what catastrophe or memory could lie behind these accounts."
    ),
    Clue(
        id: "shore", title: "The Shifting Shore", place: "BLACK SEA",
        symbol: "water.waves.and.arrow.up", category: "GEOLOGY · ACTIVE DEBATE",
        summary: "A submerged ancient shoreline raises a difficult question: how quickly did the water rise?",
        detail: "Ryan and Pitman proposed that Mediterranean water broke through the Bosporus and rapidly entered a lower Black Sea basin. Submerged shorelines and changing sediments preserve a real environmental transition; how fast it happened, and what memories it left, remain questions for the investigator."
    )
]

private func references(for clueID: String) -> [EvidenceReference] {
    switch clueID {
    case "scablands": [
        EvidenceReference(title: "USGS · Missoula and Bonneville floods review", kind: "GOVERNMENT GEOLOGY REVIEW", url: "https://www.usgs.gov/publications/missoula-and-bonneville-floods-a-review-ice-age-megafloods-columbia-river-basin"),
        EvidenceReference(title: "NASA Earth Observatory · Channeled Scablands imagery", kind: "SATELLITE IMAGERY & GEOLOGY", url: "https://science.nasa.gov/earth/earth-observatory/channeled-scablands-92025/")
    ]
    case "nuncho": [
        EvidenceReference(title: "Government of Yukon · Nun cho ga discovery", kind: "OFFICIAL DISCOVERY RELEASE", url: "https://yukon.ca/en/news/mummified-baby-woolly-mammoth-found-gold-miner-klondike"),
        EvidenceReference(title: "Yukon Geological Survey · 2022 overview", kind: "GOVERNMENT GEOLOGICAL RESEARCH", url: "https://open.yukon.ca/information/yukon-geological-survey-2022-overview"),
        EvidenceReference(title: "Smithsonian · Berezovka mammoth stomach contents", kind: "MUSEUM RESEARCH NOTE · SIBERIA", url: "https://www.si.edu/collections/snapshot/berezovka-woolly-mammoth-flesh-jar")
    ]
    case "ashfall": [
        EvidenceReference(title: "University of Nebraska · Ashfall research", kind: "MUSEUM RESEARCH SITE", url: "https://museum.unl.edu/ashfall/active-research/"),
        EvidenceReference(title: "University of Nebraska · Ashfall geology and imagery", kind: "MUSEUM GEOLOGY RESOURCE", url: "https://museum.unl.edu/ashfall/afb-geology/")
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
    case "shore": [
        EvidenceReference(title: "Ryan et al. · Black Sea flooding hypothesis", kind: "ORIGINAL RESEARCH · 1997", url: "https://doi.org/10.1016/S0025-3227(97)00007-8"),
    ]
    default: []
    }
}

private struct ArchiveView: View {
    @AppStorage("archiveLanguage") private var languageCode = "en"
    @AppStorage("archiveCurrentPage") private var storedPage = Page.briefing.rawValue
    @AppStorage("archiveCollectedClueIDs") private var storedCollectedClueIDs = ""
    @AppStorage("archiveTheory") private var storedTheory = ""
    @AppStorage("archiveOpeningDismissed") private var openingDismissed = false
    @State private var selectedClue: String?
    @State private var expandedAuditID: String?

    private var page: Page {
        get { Page(rawValue: storedPage) ?? .briefing }
        nonmutating set { storedPage = newValue.rawValue }
    }

    private var collected: Set<String> {
        Set(storedCollectedClueIDs.split(separator: ",").map(String.init))
    }

    private var theory: String? {
        storedTheory.isEmpty ? nil : storedTheory
    }

    private func recordClue(_ id: String) {
        var ids = collected
        ids.insert(id)
        storedCollectedClueIDs = ids.sorted().joined(separator: ",")
    }

    private let ink = Color(red: 0.055, green: 0.075, blue: 0.09)
    private let panel = Color(red: 0.09, green: 0.12, blue: 0.135)
    private let gold = Color(red: 0.83, green: 0.66, blue: 0.39)
    private let sea = Color(red: 0.26, green: 0.58, blue: 0.61)

    var body: some View {
        NavigationSplitView {
            sidebar
        } detail: {
            ZStack {
                ink.ignoresSafeArea()
                pageContent
                    .padding(34)
                    .frame(maxWidth: 1120, maxHeight: .infinity, alignment: .topLeading)
            }
#if os(macOS)
            .toolbar(.hidden, for: .windowToolbar)
#endif
        }
        .tint(gold)
        .environment(\.locale, Locale(identifier: languageCode))
        .sheet(isPresented: Binding(
            get: { !openingDismissed },
            set: { if !$0 { openingDismissed = true } }
        )) { openingCard }
    }

    private var sidebar: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 11) {
                Image(systemName: "water.waves")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(gold)
                    .frame(width: 42, height: 42)
                    .background(gold.opacity(0.12), in: RoundedRectangle(cornerRadius: 12))
                VStack(alignment: .leading, spacing: 2) {
                    Text("THE FLOOD ARCHIVE").font(.system(size: 12, weight: .bold, design: .rounded)).tracking(1.2)
                    Text("FIELD INVESTIGATION 01").font(.system(size: 9, weight: .medium, design: .monospaced)).tracking(0.8).foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal, 18).padding(.top, 24).padding(.bottom, 30)

            Text("YOUR DOSSIER").font(.system(size: 10, weight: .semibold, design: .monospaced)).tracking(1.3).foregroundStyle(.secondary).padding(.horizontal, 20).padding(.bottom, 10)
            ForEach(Page.allCases) { item in
                Button { page = item } label: {
                    HStack(spacing: 12) {
                        Image(systemName: item.icon).frame(width: 18)
                        Text(LocalizedStringKey(item.rawValue))
                        Spacer()
                        if item == .evidence, !collected.isEmpty {
                            Text("\(collected.count)").font(.system(size: 10, weight: .bold, design: .monospaced)).foregroundStyle(gold)
                        }
                    }
                    .font(.system(size: 13, weight: page == item ? .semibold : .regular))
                    .foregroundStyle(page == item ? .white : .white.opacity(0.66))
                    .padding(.horizontal, 14).padding(.vertical, 12)
                    .background(page == item ? gold.opacity(0.13) : .clear, in: RoundedRectangle(cornerRadius: 9))
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain).padding(.horizontal, 10).padding(.vertical, 2)
            }

            Spacer()
            Picker("Language", selection: $languageCode) {
                Text("English").tag("en")
                Text("Română").tag("ro")
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 14)
            .padding(.bottom, 12)
            VStack(alignment: .leading, spacing: 9) {
                HStack { Text("FIELD NOTES"); Spacer(); Text("\(collected.count)/\(clues.count)") }
                    .font(.system(size: 10, weight: .medium, design: .monospaced)).foregroundStyle(.secondary)
            ProgressView(value: Double(collected.count), total: Double(clues.count)).tint(sea)
                Text(LocalizedStringKey(collected.count == clues.count ? "All leads collected. Form your theory." : "Follow each lead to build the case."))
                    .font(.system(size: 11)).foregroundStyle(.white.opacity(0.56))
            }
            .padding(16).background(.white.opacity(0.035), in: RoundedRectangle(cornerRadius: 12)).padding(14)
        }
#if os(macOS)
        .frame(minWidth: 225, idealWidth: 245)
#endif
        .background(Color(red: 0.075, green: 0.095, blue: 0.108))
#if os(macOS)
        .toolbarBackground(.hidden, for: .windowToolbar)
#endif
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
        VStack(alignment: .leading, spacing: 26) {
            heroImage
            eyebrow("CONFIDENTIAL FIELD DOSSIER  /  01")
            Text("The water left\nmore than silence.")
                .font(.system(size: 48, weight: .regular, design: .serif)).tracking(-1.3).lineSpacing(-5)
            Text("A lost account. A buried city. A story that crossed generations. Follow the evidence behind the flood narrative—and decide what the traces can tell us.")
                .font(.system(size: 16)).foregroundStyle(.white.opacity(0.65)).lineSpacing(5).frame(maxWidth: 660, alignment: .leading)

            HStack(spacing: 14) {
                dossierStat(number: "06", label: "LEADS TO FOLLOW", icon: "point.topleft.down.to.point.bottomright.curvepath")
                dossierStat(number: "01", label: "OPEN CASE", icon: "folder")
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

    private var sitesPage: some View {
        ScrollView {
          VStack(alignment: .leading, spacing: 22) {
            eyebrow("EXPEDITION MAP  /  SIX ACTIVE LEADS")
            Text("Choose your next lead.").font(.system(size: 34, weight: .regular, design: .serif))
            Text("Each location holds a fragment of the case. Examine the evidence and add it to your field notes.")
                .font(.system(size: 14)).foregroundStyle(.white.opacity(0.58))
            regionalMap
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 245))], spacing: 15) {
                ForEach(clues) { clue in siteCard(clue) }
                if collected.count == clues.count { closingCard }
            }
            Spacer()
          }
        }
        .sheet(item: selectedClueBinding) { clue in clueSheet(clue) }
    }

    private func siteCard(_ clue: Clue) -> some View {
        let found = collected.contains(clue.id)
        return Button {
            selectedClue = clue.id
        } label: {
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Image(systemName: clue.symbol).font(.system(size: 19)).foregroundStyle(found ? sea : gold)
                        .frame(width: 43, height: 43).background((found ? sea : gold).opacity(0.12), in: RoundedRectangle(cornerRadius: 12))
                    Spacer()
                    Text(LocalizedStringKey(found ? "LOGGED" : "UNEXPLORED")).font(.system(size: 9, weight: .semibold, design: .monospaced)).tracking(0.8).foregroundStyle(found ? sea : .white.opacity(0.43))
                }
                VStack(alignment: .leading, spacing: 5) {
                    Text(LocalizedStringKey(clue.place)).font(.system(size: 9, weight: .medium, design: .monospaced)).tracking(1).foregroundStyle(.white.opacity(0.43))
                    Text(LocalizedStringKey(clue.title)).font(.system(size: 21, weight: .regular, design: .serif)).foregroundStyle(.white)
                    Text(LocalizedStringKey(clue.summary)).font(.system(size: 12)).foregroundStyle(.white.opacity(0.57)).lineSpacing(3).lineLimit(3)
                }
                HStack(spacing: 6) {
                    Text(LocalizedStringKey(found ? "REVIEW EVIDENCE" : "INVESTIGATE LEAD")).font(.system(size: 9, weight: .bold, design: .rounded)).tracking(0.8)
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
            if clue.id == "tablet" { ArkProportionDiagram() }
            VStack(alignment: .leading, spacing: 8) {
                eyebrow("REFERENCES · OPEN ORIGINAL SOURCES")
                ForEach(references(for: clue.id)) { referenceLink($0) }
            }.padding(.top, 4)
            HStack {
                Button("CLOSE") { selectedClue = nil }.buttonStyle(.plain).foregroundStyle(.white.opacity(0.6))
                Spacer()
                Button(LocalizedStringKey(collected.contains(clue.id) ? "IN FIELD NOTES ✓" : "ADD TO FIELD NOTES  →")) {
                    recordClue(clue.id); selectedClue = nil
                }
                .buttonStyle(.borderedProminent).tint(gold).foregroundStyle(ink).disabled(collected.contains(clue.id))
            }.padding(.top, 8)
        }
        .padding(28).frame(maxWidth: 530).background(ink).preferredColorScheme(.dark)
      }
#if os(iOS)
            .presentationDetents([.medium, .large])
#endif
    }

    private var evidencePage: some View {
      ScrollView {
        VStack(alignment: .leading, spacing: 22) {
            eyebrow("EVIDENCE WALL  /  FIELD NOTES")
            Text("The clues, connected.").font(.system(size: 34, weight: .regular, design: .serif))
            Text("Every clue enters the archive with a source. Decide which traces belong together, and what kind of event could leave them behind.")
                .font(.system(size: 14)).foregroundStyle(.white.opacity(0.58)).frame(maxWidth: 740, alignment: .leading)
            if collected.isEmpty {
                emptyState(icon: "text.magnifyingglass", title: "No evidence logged yet", subtitle: "Visit the expedition to examine your first lead.", button: "GO TO EXPEDITION") { page = .sites }
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
                HStack(spacing: 10) {
                    Image(systemName: "link").foregroundStyle(gold)
                    Text("Working question: what event could connect these flood deposits, fossils, coastlines, and ancient accounts?")
                        .font(.system(size: 12, design: .serif)).italic().foregroundStyle(.white.opacity(0.71))
                }.padding(16).background(gold.opacity(0.07), in: RoundedRectangle(cornerRadius: 11))
                Button("FORM YOUR THEORY  →") { page = .conclusion }.buttonStyle(.borderedProminent).tint(gold).foregroundStyle(ink).disabled(collected.count < clues.count)
                if collected.count < clues.count { Text("Explore all six leads to unlock the case conclusion.").font(.system(size: 11)).foregroundStyle(.white.opacity(0.4)) }
            }
            Spacer()
        }
      }
    }

    private var conclusionPage: some View {
        VStack(alignment: .leading, spacing: 22) {
            eyebrow("CASE REVIEW  /  YOUR INTERPRETATION")
            Text(LocalizedStringKey(theory == nil ? "What is your final theory?" : "Theory entered into the archive."))
                .font(.system(size: 34, weight: .regular, design: .serif))
            Text("Lay the clues beside one another. Consider the landscapes, the sudden burials, the stories, and the account of Noah. What is the strongest explanation you can make from the case?")
                .font(.system(size: 14)).foregroundStyle(.white.opacity(0.58)).lineSpacing(4).frame(maxWidth: 770, alignment: .leading)
            if collected.count < clues.count {
                emptyState(icon: "lock", title: "The case is still open", subtitle: "Collect all six leads before writing your theory.", button: "RETURN TO EXPEDITION") { page = .sites }
            } else if let theory {
                resultCard(theory)
            } else {
                VStack(spacing: 10) {
                    theoryOption("regional", title: "A great regional catastrophe began the story.", note: "One landscape, one disaster, remembered for generations.")
                    theoryOption("several", title: "Many disasters became one shared memory.", note: "Separate floods, carried together through ancient stories.")
                    theoryOption("noah", title: "Noah’s account preserves the memory of a real Flood.", note: "Connect the geological and historical clues to Genesis.")
                    theoryOption("global", title: "One worldwide cataclysm connects the clues.", note: "The scattered traces are fragments of one event.")
                }
            }
            Spacer()
        }
    }

    @ViewBuilder private func clueIllustration(_ clue: Clue) -> some View {
        switch clue.id {
        case "scablands":
            ConceptDiagram(kind: "missoula", title: "One lake. Repeated regional floods.",
                analogy: "Imagine a plug holding back a bathtub: when it opens, water rushes out. Lake Missoula was vastly larger, and the real ice-dam mechanics were more complex.",
                note: "USGS research links the Scablands to repeated glacial-lake outbursts. This is evidence for regional megafloods; it does not by itself establish a worldwide flood.",
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
                note: "The game places the Genesis account beside Mesopotamian texts. Shared themes invite comparison; the texts themselves do not prove that every account describes the same event.",
                steps: [
                    DiagramStep(title: "GENESIS", detail: "Read the account in context.", symbol: "book.closed.fill"),
                    DiagramStep(title: "TABLET", detail: "Examine the cuneiform record.", symbol: "scroll.fill"),
                    DiagramStep(title: "COMPARE", detail: "Mark shared and different details.", symbol: "arrow.left.arrow.right"),
                    DiagramStep(title: "INTERPRET", detail: "Weigh possible connections.", symbol: "text.magnifyingglass")
                ])
        case "shore":
            ConceptDiagram(kind: "blackSea", title: "The Black Sea rapid-inflow hypothesis.",
                analogy: "Picture water spilling over a low divider between two basins. The Bosporus proposal applies that idea to ancient shorelines and changing salinity; the rate and scale remain part of the hypothesis.",
                note: "Ryan and Pitman proposed rapid inflow from the Mediterranean into a lower Black Sea basin. Label this as a hypothesis, not an established global flood.",
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
        Button { storedTheory = id } label: {
            HStack(alignment: .top, spacing: 13) {
                Image(systemName: "circle").font(.system(size: 16)).foregroundStyle(gold).padding(.top, 2)
                VStack(alignment: .leading, spacing: 5) {
                    Text(LocalizedStringKey(title)).font(.system(size: 15, weight: .medium)).foregroundStyle(.white)
                    Text(LocalizedStringKey(note)).font(.system(size: 11)).foregroundStyle(.white.opacity(0.5))
                }
                Spacer()
                Image(systemName: "arrow.right").foregroundStyle(gold.opacity(0.8))
            }.padding(15).background(panel, in: RoundedRectangle(cornerRadius: 11))
                .overlay(RoundedRectangle(cornerRadius: 11).stroke(.white.opacity(0.06), lineWidth: 1))
        }.buttonStyle(.plain)
    }

    @ViewBuilder private func resultCard(_ id: String) -> some View {
        let title: String = switch id {
        case "regional": "A regional disaster can become a world-changing story."
        case "several": "Many waters. Many memories. One enduring mystery."
        case "noah": "You connected the geological and historical clues to Noah’s account. Your theory is now part of the archive."
        default: "One catastrophe. A world reshaped by water. Your theory connects the scattered clues to a global event."
        }
        let body: String = switch id {
        case "regional": "Flood deposits and old narratives make regional disasters a compelling possibility. You connected a documented landscape with a story carried through generations."
        case "several": "The layers belong to different places and times. That leaves room for more than one disaster to echo through stories passed between generations."
        case "noah": "You connected flood deposits, submerged landscapes, ancient flood traditions, and the Genesis account. Your case file records the clues that led you to this theory."
        default: "You assembled evidence of catastrophic flooding, extensive sedimentary layers, fossils, submerged coastlines, and ancient flood traditions into a worldwide flood theory. The investigation continues as new clues emerge."
        }
        VStack(alignment: .leading, spacing: 15) {
            HStack(spacing: 8) { Image(systemName: "checkmark.seal.fill").foregroundStyle(sea); Text("INVESTIGATION COMPLETE").font(.system(size: 9, weight: .bold, design: .monospaced)).tracking(1).foregroundStyle(sea) }
            Text(LocalizedStringKey(title)).font(.system(size: 23, design: .serif))
            Text(LocalizedStringKey(body)).font(.system(size: 13)).foregroundStyle(.white.opacity(0.65)).lineSpacing(4)
            Divider().overlay(.white.opacity(0.1))
            Text("A good investigator records both the clues and the theory they support. Reopen the archive whenever you want to examine a source again.")
                .font(.system(size: 11)).foregroundStyle(.white.opacity(0.46)).lineSpacing(3)
            Button("REOPEN CASE") { storedTheory = "" }.buttonStyle(.plain).font(.system(size: 10, weight: .bold, design: .monospaced)).tracking(1).foregroundStyle(gold).padding(.top, 3)
        }.padding(22).background(panel, in: RoundedRectangle(cornerRadius: 14)).frame(maxWidth: 760, alignment: .leading)
    }

    private var closingCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: "sparkle.magnifyingglass").font(.system(size: 20)).foregroundStyle(gold)
            Text("The case is yours to close.").font(.system(size: 21, design: .serif))
            Text("You have six leads. Now connect what you found and write your theory.").font(.system(size: 12)).foregroundStyle(.white.opacity(0.55))
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
            Text("Begin with ancient flood accounts from Mesopotamia. Follow six source-linked leads through real places, specimens, and texts. Examine the observations, open the original references, then decide how the evidence fits together.")
                .font(.system(size: 13)).foregroundStyle(.white.opacity(0.63)).lineSpacing(4)
            Text("Your mission: follow the trail, examine each clue, and record what the evidence can—and cannot—tell you.")
                .font(.system(size: 12, weight: .medium)).foregroundStyle(.white.opacity(0.82)).lineSpacing(3)
            HStack { Spacer(); Button("OPEN THE CASE  →") { openingDismissed = true }.buttonStyle(.borderedProminent).tint(gold).foregroundStyle(ink) }
        }.padding(26).frame(maxWidth: 490).background(ink).preferredColorScheme(.dark)
#if os(iOS)
            .presentationDetents([.medium, .large])
#endif
    }

    private func dossierStat(number: String, label: String, icon: String) -> some View {
        VStack(alignment: .leading, spacing: 13) {
            Image(systemName: icon).font(.system(size: 15)).foregroundStyle(sea)
            Text(number).font(.system(size: 30, weight: .regular, design: .serif)).foregroundStyle(.white)
            Text(LocalizedStringKey(label)).font(.system(size: 9, weight: .medium, design: .monospaced)).tracking(0.8).foregroundStyle(.white.opacity(0.42))
        }.frame(width: 175, height: 112, alignment: .leading).padding(.leading, 17).background(panel, in: RoundedRectangle(cornerRadius: 13))
    }

    private func eyebrow(_ text: String) -> some View {
        Text(LocalizedStringKey(text)).font(.system(size: 9, weight: .semibold, design: .monospaced)).tracking(1.4).foregroundStyle(sea)
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
                mapPin("SCABLANDS", x: 0.28, y: 0.47).frame(width: 340, height: 150)
                mapPin("YUKON", x: 0.32, y: 0.19).frame(width: 340, height: 150)
                mapPin("NEBRASKA", x: 0.53, y: 0.63).frame(width: 340, height: 150)
            }.frame(maxWidth: .infinity).frame(height: 185).clipped()
            Text("Schematic map · plotted locations are approximate. Regional flood evidence is not, by itself, evidence of a worldwide event.").font(.system(size: 10)).foregroundStyle(.white.opacity(0.48))
        }.padding(17).background(panel, in: RoundedRectangle(cornerRadius: 17))
    }

    private func mapPin(_ label: String, x: CGFloat, y: CGFloat) -> some View {
        GeometryReader { geo in
            VStack(spacing: 3) { Circle().fill(gold).frame(width: 8, height: 8).overlay(Circle().stroke(ink, lineWidth: 2)); Text(LocalizedStringKey(label)).font(.system(size: 7, weight: .bold, design: .monospaced)).foregroundStyle(.white).fixedSize() }
                .position(x: geo.size.width*x, y: geo.size.height*y)
        }
    }

    private var northAmericaPage: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                eyebrow("EXPEDITION  /  NORTH AMERICA")
                Text("A continent carved by water—and time.").font(.system(size: 34, weight: .regular, design: .serif))
                Text("Explore documented flood landscapes and exceptional fossil preservation. The map is schematic; each case is linked to its institutional source.").font(.system(size: 14)).foregroundStyle(.white.opacity(0.62)).lineSpacing(4)
                regionalMap
                photoCase(title: "The Channeled Scablands", subtitle: "Washington · repeated Ice Age outburst floods", url: "https://science.nasa.gov/earth/earth-observatory/channeled-scablands-92025/", image: "https://assets.science.nasa.gov/content/dam/science/esd/eo/images/imagerecords/92000/92025/potholescoulee_oli_2017245_lrg.jpg", source: "NASA Earth Observatory · USGS review")
                photoCase(title: "Nun cho ga", subtitle: "Yukon · a baby mammoth preserved in permafrost", url: "https://yukon.ca/en/news/mummified-baby-woolly-mammoth-found-gold-miner-klondike", image: "https://s.hdnux.com/photos/01/26/30/16/22643585/4/rawImage.jpg", source: "Government of Yukon · photo credit: Treadstone Gold")
                photoCase(title: "Ashfall Fossil Beds", subtitle: "Nebraska · articulated fossils in volcanic ash", url: "https://museum.unl.edu/ashfall/ashfall-fossil-beds/", image: "https://museum.unl.edu/sites/unl.edu.nebraska-state-museum/files/styles/4_3_720x540/public/media/image/rhino_gallery_close_up.jpg?itok=tm_thQnJ", source: "University of Nebraska State Museum")
                Text("Cross-check: the grass-filled Berezovka mammoth was excavated in northeastern Siberia. The famous fossil of a marine reptile giving birth was discovered in China. Both are comparative clues, not North American finds.").font(.system(size: 12)).foregroundStyle(gold.opacity(0.9)).lineSpacing(4).padding(15).background(gold.opacity(0.07), in: RoundedRectangle(cornerRadius: 12))
            }.frame(maxWidth: 900, alignment: .leading)
        }
    }

    private var mediaPage: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                eyebrow("FIELD MEDIA  /  WATCH & EXAMINE")
                Text("See the evidence in the landscape.").font(.system(size: 34, weight: .regular, design: .serif))
                Text("Video links open the original publisher. An internet connection is needed; media remains credited to its source.").font(.system(size: 14)).foregroundStyle(.white.opacity(0.58))
                mediaCard(title: "The Great Missoula Floods", description: "USGS field talk on the Ice Age floods and the landscape they carved.", source: "USGS · PubTalk", url: "https://www.usgs.gov/media/videos/pubtalk-92010-great-missoula-and-ice-age-floods-natl-geologic-trail", symbol: "play.rectangle.fill")
                mediaCard(title: "Ashfall Fossil Beds: Virtual Field Trip", description: "Explore the Nebraska fossil site and its ash layers with the Nebraska State Museum.", source: "University of Nebraska State Museum", url: "https://museum.unl.edu/education/virtual-field-trips/", symbol: "play.rectangle.fill")
                mediaCard(title: "Berezovka: the Siberian mammoth", description: "Smithsonian account of the specimen and its stomach contents, including grasses.", source: "Smithsonian National Museum of Natural History", url: "https://www.si.edu/collections/snapshot/berezovka-woolly-mammoth-flesh-jar", symbol: "photo")
                timelineGraphic
                Text("The timeline uses broad published age ranges for context; it does not imply that these separate events happened together.").font(.system(size: 10)).foregroundStyle(.white.opacity(0.45))
            }.frame(maxWidth: 900, alignment: .leading)
        }
    }

    private var claimAuditPage: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                eyebrow("EVIDENCE LAB  /  CLAIMS FROM THE SHARED DOSSIER")
                Text("Follow every claim to its source.").font(.system(size: 34, weight: .regular, design: .serif))
                Text("A source-led case file of evidence and arguments cited by flood proponents. Each entry links to scientific, museum, or government records and to published flood-geology interpretations. Source labels identify the publication type.")
                    .font(.system(size: 14)).foregroundStyle(.white.opacity(0.62)).lineSpacing(4).frame(maxWidth: 800, alignment: .leading)
                HStack(spacing: 8) {
                    Image(systemName: "info.circle.fill").foregroundStyle(gold)
                    Text("Every item links to its source. Publication labels distinguish peer-reviewed studies, museum records, government archives, and creationist-perspective papers.")
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
                    auditParagraph("FLOOD-CASE INTERPRETATION", text: file.context, color: gold)
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

    private func referenceLink(_ reference: EvidenceReference) -> some View {
        Link(destination: URL(string: reference.url)!) {
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "arrow.up.right.square").font(.system(size: 11)).foregroundStyle(gold).padding(.top, 1)
                VStack(alignment: .leading, spacing: 2) {
                    Text(LocalizedStringKey(reference.title)).font(.system(size: 11, weight: .medium)).foregroundStyle(.white.opacity(0.84))
                    Text(LocalizedStringKey(reference.kind)).font(.system(size: 8, weight: .medium, design: .monospaced)).tracking(0.45).foregroundStyle(sea)
                }
                Spacer(minLength: 0)
            }.contentShape(Rectangle())
        }.buttonStyle(.plain)
    }

    private func photoCase(title: String, subtitle: String, url: String, image: String, source: String) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            AsyncImage(url: URL(string: image)) { phase in
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

private struct DiagramStep: Identifiable {
    let title: String
    let detail: String
    let symbol: String
    var id: String { title }
}

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
