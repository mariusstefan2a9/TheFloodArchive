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
    case conclusion = "Final Theory"

    var id: String { rawValue }
    var icon: String {
        switch self {
        case .briefing: "doc.text.magnifyingglass"
        case .sites: "location.north.circle"
        case .evidence: "point.3.connected.trianglepath.dotted"
        case .northAmerica: "map"
        case .media: "play.rectangle"
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

private let clues: [Clue] = [
    Clue(
        id: "scablands", title: "The Scablands Scar", place: "EASTERN WASHINGTON · NORTH AMERICA", symbol: "water.waves",
        category: "GEOLOGY · CONFIRMED ICE-AGE MEGAFLOODS",
        summary: "Basalt coulees, giant ripple marks, and gravel bars record immense outburst floods.",
        detail: "USGS research links the Channeled Scablands to repeated outburst floods from glacial Lake Missoula during the last Ice Age. These are well-supported, extraordinary regional floods. Their North American setting and geologic ages do not by themselves identify them with Noah’s Flood or establish a worldwide event."
    ),
    Clue(
        id: "nuncho", title: "Nun cho ga", place: "YUKON · NORTH AMERICA", symbol: "pawprint.fill",
        category: "PALEONTOLOGY · PERMAFROST PRESERVATION",
        summary: "A remarkably preserved baby mammoth emerged from Yukon permafrost in 2022.",
        detail: "Nun cho ga is a female woolly mammoth calf found in Yukon in 2022, in Tr’ondëk Hwëch’in traditional territory. The find is an extraordinary example of permafrost preservation. It is not the famous Berezovka mammoth with analyzed stomach contents: that specimen came from Siberia. Neither specimen alone establishes a global flood."
    ),
    Clue(
        id: "ashfall", title: "The Ashfall Nursery", place: "NEBRASKA · NORTH AMERICA", symbol: "leaf",
        category: "FOSSIL SITE · VOLCANIC ASH",
        summary: "A Nebraska fossil bed preserves articulated animals in a layer of volcanic ash.",
        detail: "At Ashfall Fossil Beds, Nebraska, the University of Nebraska State Museum describes a Miocene assemblage buried by volcanic ash from an eruption in what is now Idaho. Researchers interpret the ash and groundwater as the cause of rapid burial and preservation. Pregnant animals are among the site's finds; this is not the famous marine-reptile fossil caught giving birth, which comes from China."
    ),
    Clue(
        id: "silt", title: "The Silt Line", place: "MESOPOTAMIA", symbol: "water.waves",
        category: "ARCHAEOLOGY · MESOPOTAMIA",
        summary: "A band of water-laid clay cuts through the remains of an ancient settlement.",
        detail: "Excavations at several Mesopotamian cities found flood deposits. Their layers differ in place and date: they are evidence of serious local floods, but do not form one worldwide layer or identify a single event as Noah’s Flood."
    ),
    Clue(
        id: "tablet", title: "The Broken Tablet", place: "ANCIENT NEAR EAST", symbol: "scroll",
        category: "ANCIENT TEXT · CUNEIFORM",
        summary: "A flood survivor tells a story of a warning, a vessel, and a ruined world.",
        detail: "Mesopotamian flood narratives, including the Epic of Gilgamesh and Atrahasis, share themes with the Genesis account. The surviving written versions are ancient; similarities show a shared cultural world, but cannot by themselves prove exactly which events inspired each story."
    ),
    Clue(
        id: "shore", title: "The Shifting Shore", place: "BLACK SEA",
        symbol: "water.waves.and.arrow.up", category: "GEOLOGY · ACTIVE DEBATE",
        summary: "A submerged ancient shoreline raises a difficult question: how quickly did the water rise?",
        detail: "One proposal links a rapid rise in the Black Sea to memories behind flood traditions. Researchers dispute the speed and scale of the event; other evidence supports a more gradual change. It remains a hypothesis, not a confirmed identification of Noah’s Flood."
    )
]

private struct ArchiveView: View {
    @State private var page: Page = .briefing
    @State private var collected: Set<String> = []
    @State private var selectedClue: String?
    @State private var theory: String?
    @State private var showOpening = true

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
        .sheet(isPresented: $showOpening) { openingCard }
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
                        Text(item.rawValue)
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
            VStack(alignment: .leading, spacing: 9) {
                HStack { Text("FIELD NOTES"); Spacer(); Text("\(collected.count)/\(clues.count)") }
                    .font(.system(size: 10, weight: .medium, design: .monospaced)).foregroundStyle(.secondary)
            ProgressView(value: Double(collected.count), total: Double(clues.count)).tint(sea)
                Text(collected.count == clues.count ? "All leads collected. Form your theory." : "Follow each lead to build the case.")
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
                Text("“The past is never buried as deep as it seems.”")
                    .font(.system(size: 13, design: .serif)).italic().foregroundStyle(.white.opacity(0.55))
            }
        }
    }

    private var sitesPage: some View {
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
                    Text(found ? "LOGGED" : "UNEXPLORED").font(.system(size: 9, weight: .semibold, design: .monospaced)).tracking(0.8).foregroundStyle(found ? sea : .white.opacity(0.43))
                }
                VStack(alignment: .leading, spacing: 5) {
                    Text(clue.place).font(.system(size: 9, weight: .medium, design: .monospaced)).tracking(1).foregroundStyle(.white.opacity(0.43))
                    Text(clue.title).font(.system(size: 21, weight: .regular, design: .serif)).foregroundStyle(.white)
                    Text(clue.summary).font(.system(size: 12)).foregroundStyle(.white.opacity(0.57)).lineSpacing(3).lineLimit(3)
                }
                HStack(spacing: 6) {
                    Text(found ? "REVIEW EVIDENCE" : "INVESTIGATE LEAD").font(.system(size: 9, weight: .bold, design: .rounded)).tracking(0.8)
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
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                Image(systemName: clue.symbol).font(.system(size: 20)).foregroundStyle(gold)
                Spacer()
                Text(clue.category).font(.system(size: 9, weight: .semibold, design: .monospaced)).tracking(0.8).foregroundStyle(sea)
            }
            Text(clue.title).font(.system(size: 30, weight: .regular, design: .serif))
            Text(clue.summary).font(.system(size: 15, weight: .medium)).foregroundStyle(.white.opacity(0.78))
            Text(clue.detail).font(.system(size: 13)).foregroundStyle(.white.opacity(0.64)).lineSpacing(5)
            HStack {
                Button("CLOSE") { selectedClue = nil }.buttonStyle(.plain).foregroundStyle(.white.opacity(0.6))
                Spacer()
                Button(collected.contains(clue.id) ? "IN FIELD NOTES ✓" : "ADD TO FIELD NOTES  →") {
                    collected.insert(clue.id); selectedClue = nil
                }
                .buttonStyle(.borderedProminent).tint(gold).foregroundStyle(ink).disabled(collected.contains(clue.id))
            }.padding(.top, 8)
        }
        .padding(28).frame(maxWidth: 530).background(ink).preferredColorScheme(.dark)
#if os(iOS)
            .presentationDetents([.medium, .large])
#endif
    }

    private var evidencePage: some View {
        VStack(alignment: .leading, spacing: 22) {
            eyebrow("EVIDENCE WALL  /  FIELD NOTES")
            Text("The clues, connected.").font(.system(size: 34, weight: .regular, design: .serif))
            Text("Keep observation and interpretation in view. A clue can be real while its connection to Noah’s Flood remains uncertain.")
                .font(.system(size: 14)).foregroundStyle(.white.opacity(0.58)).frame(maxWidth: 740, alignment: .leading)
            if collected.isEmpty {
                emptyState(icon: "text.magnifyingglass", title: "No evidence logged yet", subtitle: "Visit the expedition to examine your first lead.", button: "GO TO EXPEDITION") { page = .sites }
            } else {
                VStack(spacing: 11) {
                    ForEach(clues.filter { collected.contains($0.id) }) { clue in
                        HStack(alignment: .top, spacing: 15) {
                            Image(systemName: clue.symbol).font(.system(size: 17)).foregroundStyle(sea).frame(width: 39, height: 39).background(sea.opacity(0.12), in: RoundedRectangle(cornerRadius: 11))
                            VStack(alignment: .leading, spacing: 6) {
                                HStack { Text(clue.title).font(.system(size: 17, design: .serif)); Spacer(); Text(clue.category).font(.system(size: 8, weight: .medium, design: .monospaced)).foregroundStyle(gold.opacity(0.85)) }
                                Text(clue.detail).font(.system(size: 12)).foregroundStyle(.white.opacity(0.59)).lineSpacing(3)
                            }
                        }.padding(16).background(panel, in: RoundedRectangle(cornerRadius: 12))
                    }
                }
                HStack(spacing: 10) {
                    Image(systemName: "link").foregroundStyle(gold)
                    Text("Working question: can evidence for regional floods identify one specific event behind the wider story?")
                        .font(.system(size: 12, design: .serif)).italic().foregroundStyle(.white.opacity(0.71))
                }.padding(16).background(gold.opacity(0.07), in: RoundedRectangle(cornerRadius: 11))
                Button("FORM YOUR THEORY  →") { page = .conclusion }.buttonStyle(.borderedProminent).tint(gold).foregroundStyle(ink).disabled(collected.count < clues.count)
                if collected.count < clues.count { Text("Explore all six leads to unlock the case conclusion.").font(.system(size: 11)).foregroundStyle(.white.opacity(0.4)) }
            }
            Spacer()
        }
    }

    private var conclusionPage: some View {
        VStack(alignment: .leading, spacing: 22) {
            eyebrow("CASE REVIEW  /  YOUR INTERPRETATION")
            Text(theory == nil ? "What does the evidence say?" : "Case note saved.")
                .font(.system(size: 34, weight: .regular, design: .serif))
            Text("Choose the conclusion that best describes the evidence you examined. Your personal beliefs can be part of your interpretation; this question asks what the physical and textual traces establish on their own.")
                .font(.system(size: 14)).foregroundStyle(.white.opacity(0.58)).lineSpacing(4).frame(maxWidth: 770, alignment: .leading)
            if collected.count < clues.count {
                emptyState(icon: "lock", title: "The case is still open", subtitle: "Collect all six leads before writing your theory.", button: "RETURN TO EXPEDITION") { page = .sites }
            } else if let theory {
                resultCard(theory)
            } else {
                VStack(spacing: 10) {
                    theoryOption("regional", title: "A major regional flood left a lasting memory.", note: "Supported as a possibility by regional flood evidence and ancient traditions.")
                    theoryOption("several", title: "Several floods may have shaped flood traditions.", note: "Consistent with multiple flood deposits and varied ancient accounts.")
                    theoryOption("noah", title: "One specific flood was Noah’s Flood.", note: "A faith-based interpretation; the collected clues do not identify one event conclusively.")
                    theoryOption("global", title: "The evidence establishes a worldwide flood.", note: "The evidence examined here does not establish a worldwide event.")
                }
            }
            Spacer()
        }
    }

    private func theoryOption(_ id: String, title: String, note: String) -> some View {
        Button { theory = id } label: {
            HStack(alignment: .top, spacing: 13) {
                Image(systemName: "circle").font(.system(size: 16)).foregroundStyle(gold).padding(.top, 2)
                VStack(alignment: .leading, spacing: 5) {
                    Text(title).font(.system(size: 15, weight: .medium)).foregroundStyle(.white)
                    Text(note).font(.system(size: 11)).foregroundStyle(.white.opacity(0.5))
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
        case "noah": "You connect the traces to Noah’s Flood through faith and interpretation."
        default: "Your claim reaches beyond what these clues can establish."
        }
        let body: String = switch id {
        case "regional": "Flood deposits and old narratives make regional disasters a compelling possibility. The evidence does not point to one confirmed event, but the investigation has found real traces worth following."
        case "several": "The layers belong to different places and times. That leaves room for more than one disaster to echo through stories passed between generations."
        case "noah": "The clues include real regional flood deposits and ancient flood traditions. Connecting them to Noah is a meaningful interpretation, while the specific historical link remains unconfirmed by these clues alone."
        default: "The clues in this case document regional events and ancient stories. They do not demonstrate a flood covering the entire planet. A careful investigator marks the gap between evidence and claim."
        }
        VStack(alignment: .leading, spacing: 15) {
            HStack(spacing: 8) { Image(systemName: "checkmark.seal.fill").foregroundStyle(sea); Text("INVESTIGATION COMPLETE").font(.system(size: 9, weight: .bold, design: .monospaced)).tracking(1).foregroundStyle(sea) }
            Text(title).font(.system(size: 23, design: .serif))
            Text(body).font(.system(size: 13)).foregroundStyle(.white.opacity(0.65)).lineSpacing(4)
            Divider().overlay(.white.opacity(0.1))
            Text("Your faith and the historical investigation can sit beside each other. This case records what the evidence supports, what remains debated, and where interpretation begins.")
                .font(.system(size: 11)).foregroundStyle(.white.opacity(0.46)).lineSpacing(3)
            Button("REOPEN CASE") { theory = nil }.buttonStyle(.plain).font(.system(size: 10, weight: .bold, design: .monospaced)).tracking(1).foregroundStyle(gold).padding(.top, 3)
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
            Text(title).font(.system(size: 20, design: .serif))
            Text(subtitle).font(.system(size: 12)).foregroundStyle(.white.opacity(0.55))
            Button(button, action: action).buttonStyle(.borderedProminent).tint(gold).foregroundStyle(ink).padding(.top, 5)
        }.frame(maxWidth: .infinity).padding(38).background(panel, in: RoundedRectangle(cornerRadius: 14)).padding(.top, 12)
    }

    private var openingCard: some View {
        VStack(alignment: .leading, spacing: 17) {
            HStack { Text("CASE 001").font(.system(size: 9, weight: .bold, design: .monospaced)).tracking(1.2).foregroundStyle(gold); Spacer(); Image(systemName: "water.waves").foregroundStyle(sea) }
            Text("A message beneath the mud.").font(.system(size: 26, design: .serif))
            Text("The expedition begins in southern Mesopotamia. A field team has uncovered a sealed archive near an old river channel. Inside: fragments of a flood story and a dossier pointing to six locations across two continents.")
                .font(.system(size: 13)).foregroundStyle(.white.opacity(0.63)).lineSpacing(4)
            Text("Your mission: follow the trail, examine each clue, and record what the evidence can—and cannot—tell you.")
                .font(.system(size: 12, weight: .medium)).foregroundStyle(.white.opacity(0.82)).lineSpacing(3)
            HStack { Spacer(); Button("OPEN THE CASE  →") { showOpening = false }.buttonStyle(.borderedProminent).tint(gold).foregroundStyle(ink) }
        }.padding(26).frame(maxWidth: 490).background(ink).preferredColorScheme(.dark)
#if os(iOS)
            .presentationDetents([.medium, .large])
#endif
    }

    private func dossierStat(number: String, label: String, icon: String) -> some View {
        VStack(alignment: .leading, spacing: 13) {
            Image(systemName: icon).font(.system(size: 15)).foregroundStyle(sea)
            Text(number).font(.system(size: 30, weight: .regular, design: .serif)).foregroundStyle(.white)
            Text(label).font(.system(size: 9, weight: .medium, design: .monospaced)).tracking(0.8).foregroundStyle(.white.opacity(0.42))
        }.frame(width: 175, height: 112, alignment: .leading).padding(.leading, 17).background(panel, in: RoundedRectangle(cornerRadius: 13))
    }

    private func eyebrow(_ text: String) -> some View {
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
                mapPin("SCABLANDS", x: 0.28, y: 0.47).frame(width: 340, height: 150)
                mapPin("YUKON", x: 0.32, y: 0.19).frame(width: 340, height: 150)
                mapPin("NEBRASKA", x: 0.53, y: 0.63).frame(width: 340, height: 150)
            }.frame(maxWidth: .infinity).frame(height: 185).clipped()
            Text("Schematic map · plotted locations are approximate. Regional flood evidence is not, by itself, evidence of a worldwide event.").font(.system(size: 10)).foregroundStyle(.white.opacity(0.48))
        }.padding(17).background(panel, in: RoundedRectangle(cornerRadius: 17))
    }

    private func mapPin(_ label: String, x: CGFloat, y: CGFloat) -> some View {
        GeometryReader { geo in
            VStack(spacing: 3) { Circle().fill(gold).frame(width: 8, height: 8).overlay(Circle().stroke(ink, lineWidth: 2)); Text(label).font(.system(size: 7, weight: .bold, design: .monospaced)).foregroundStyle(.white).fixedSize() }
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

    private func photoCase(title: String, subtitle: String, url: String, image: String, source: String) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            AsyncImage(url: URL(string: image)) { phase in
                if let img = phase.image { img.resizable().scaledToFill() }
                else { ZStack { LinearGradient(colors: [panel, sea.opacity(0.35)], startPoint: .topLeading, endPoint: .bottomTrailing); Image(systemName: "mountain.2.fill").font(.system(size: 42)).foregroundStyle(.white.opacity(0.35)) } }
            }.frame(height: 190).clipped()
            VStack(alignment: .leading, spacing: 6) {
                Text(title).font(.system(size: 22, design: .serif))
                Text(subtitle).font(.system(size: 12)).foregroundStyle(.white.opacity(0.6))
                HStack { Text(source).font(.system(size: 9, design: .monospaced)).foregroundStyle(sea); Spacer(); Link("OPEN SOURCE ↗", destination: URL(string: url)!).font(.system(size: 9, weight: .bold, design: .monospaced)).tint(gold) }
                    .padding(.top, 5)
            }.padding(16)
        }.background(panel, in: RoundedRectangle(cornerRadius: 15)).clipShape(RoundedRectangle(cornerRadius: 15))
    }

    private func mediaCard(title: String, description: String, source: String, url: String, symbol: String) -> some View {
        Link(destination: URL(string: url)!) {
            HStack(spacing: 15) {
                ZStack { RoundedRectangle(cornerRadius: 12).fill(gold.opacity(0.13)); Image(systemName: symbol).font(.system(size: 20)).foregroundStyle(gold) }.frame(width: 54, height: 54)
                VStack(alignment: .leading, spacing: 5) { Text(title).font(.system(size: 18, design: .serif)).foregroundStyle(.white); Text(description).font(.system(size: 12)).foregroundStyle(.white.opacity(0.56)).lineSpacing(2); Text(source.uppercased()).font(.system(size: 8, weight: .medium, design: .monospaced)).tracking(0.7).foregroundStyle(sea).padding(.top, 3) }
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
                    Text("Nun cho ga · Yukon · ~30,000 years; Missoula floods · Washington · broad interval often given as ~20,000–14,000 years").font(.system(size: 11)).foregroundStyle(.white.opacity(0.58)).lineSpacing(3)
                }
            }
            Text("Not to scale. The Siberian Berezovka specimen is a comparison, not a North American site.").font(.system(size: 9)).foregroundStyle(gold.opacity(0.8))
        }.padding(18).background(panel, in: RoundedRectangle(cornerRadius: 15))
    }
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
