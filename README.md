# The Flood Archive

**A source-led flood investigation game for macOS, iPadOS, and iPhone.** In the English-language experience, players open a source record to unlock each evidence challenge, record case-board findings whose basis the source records support, then choose their own theory about Noah’s Flood. Missions link real places, specimens, and texts to their sources, while identifying Flood-geology interpretations as interpretations.

## Languages

The interface and investigation content launch in English. Use the English / Română segmented control in the sidebar to switch to Romanian; the choice is saved on the device. Original publication titles and institution names remain in their published language so sources are easy to find. Bible references and the *Insight on the Scriptures* entries that exist in Romanian link to both editions: the active language opens its own edition, and a small EN / RO button opens the other. The Romanian Bible links use the New World Translation on jw.org; the Romanian *Insight* entries open on wol.jw.org. The Romanian edition has no separate “Ark” entry, so its Romanian link opens “Potopul din zilele lui Noe”, which covers the ark’s capacity.

Navigation follows JW Library. On every device a bottom bar holds five tabs: Home, Missions, Evidence, Library, and Theory; the active tab is highlighted, and pages opened from a tab show a Back button in the top bar. Home shows what remains of the investigation with a Continue button, the tutorial, language and restart settings, and useful links. Library holds the Claim Audit, Field Media, and North America. Missions open full screen on iPhone and iPad, and in a large window on Mac.

Missions unlock in order: a mission shows only as a locked, classified lead until the missions before it are cleared. The Biblical Record mission appears only after the player saves a theory that the Flood happened (Noah’s account preserves a real Flood, or one worldwide cataclysm connects the clues); the case board and the final theory open after three cleared missions.

Bible references appear as blue citations (for example, Matthew 24:37–39). Tapping one opens a short summary of the passage written for the game; tapping again closes it. The New World Translation text itself is not copied into the app, because it is copyrighted.

The game is an investigation interface, not a report of a newly discovered archive. Its named places, specimens, and ancient texts are real and linked to their sources; players assemble them into a theory.

## Open in Xcode

1. Copy this folder to your MacBook.
2. Open `TheFloodArchive.xcodeproj` in Xcode.
3. Select **My Mac** to run on macOS, or connect and select your iPad or iPhone.
4. For your own iPad or iPhone, sign in to Xcode with your Apple Account and select your **Personal Team** under **Signing & Capabilities**. On the device, enable Developer Mode if Xcode asks.
5. Press **Run**. Personal on-device development does not require the paid Apple Developer Program. App Store distribution is separate.

## Included

- One universal Xcode project for Mac, iPad, and iPhone, with a custom illustrated title scene, mission map, clue collection, evidence wall, final theory, and reference-linked **Claim Audit**. Each Claim Audit file has three parts: what is observed, the argument built on those clues, and what the cited research concludes.
- Twenty-one evidence files covering regional megafloods, the Black Sea rapid-inflow hypothesis, post-Ice-Age sea-level rise, marine fossils at elevation, Tapeats/Coconino megasequences, polystrate trees, dinosaur soft-tissue reports, unconformities, folded strata, catastrophic plate tectonics, RATE helium-in-zircon claims, fossil succession, a fossil preserving a marine reptile giving birth, Berezovka’s last meal, mammoth die-off arguments, flood traditions, the smoothed-Earth water-volume calculation, Ark-capacity claims, the proposed scriptural water source, biblical testimony cited by later writers, and the historical water-pressure fossilization estimate.
- North American cases for the Channeled Scablands, Yukon mammoths, and Ashfall Fossil Beds in Nebraska.
- Images that load from NASA, Yukon, and the University of Nebraska; a USGS lecture and an Ashfall Museum video embedded in the game; an official 360° tour and Nebraska Studies multimedia story open at their publishers. Credits and source links appear beside the media.
- A timeline that keeps separate places, specimens, and geological periods distinct.
- A case board where each link or difference needs a basis (region, measured dates, or kind of record) that the clues' records support; open questions are saved but do not unlock the final theory. Theories that join every clue into one event ask for the player's explanation of the places and periods involved.
- **Restart the case** in the sidebar clears the saved missions, answers, opened sources, findings, and theory on the device; the language choice is kept.

## Source labels

Each Claim Audit reference is labeled by source type, including peer-reviewed research, government or museum record, historical expedition account, Bible text, and Biblical encyclopedia argument. The flood-related entries in *Insight on the Scriptures* are presented as an encyclopedia's argument, interpretation, estimates, and scriptural reasoning, attributed to the named entry and quoted briefly where useful. Research, museum, and government sources are linked to the observations and records they document. Players compare these records with the encyclopedia's Flood argument and form their own theory.

The evidence files draw on the Flood-related argument families in the reviewed *Insight on the Scriptures* entries “Flood of Noah’s Day,” “Deluge,” “Ark,” and “Noah.” They are a curated selection, not a transcription of every line or mention in the full jw.org and wol.jw.org archives. Each related encyclopedia entry is linked from its evidence card. Research references identify the published measurements, specimens, and interpretations that players can compare with the encyclopedia's case.

Notable scientific and institutional records include the USGS review of the Missoula floods; peer-reviewed Black Sea research by Ryan and colleagues; the Barbados sea-level record; Grand Canyon and Yukon park/government geology; the Nebraska State Museum's Ashfall research; Schweitzer and colleagues' dinosaur-protein studies; sedimentology at Joggins; and the PLOS ONE report of the Chaohusaurus birth-position fossil.

The grass-filled Berezovka mammoth was found in Siberia, not North America. The Chaohusaurus birth-position fossil came from China. Nun cho ga is the separate mummified calf discovered in Yukon. The app distinguishes these well-known examples instead of relocating them to North America.

Images and streamed videos require an internet connection. The USGS lecture is public domain; the Ashfall video is embedded from the University of Nebraska State Museum's official YouTube channel. Neither is bundled into this project. The hero illustration and map are original SwiftUI artwork; the map is labeled schematic.
