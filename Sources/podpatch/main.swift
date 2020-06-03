import Foundation
import PodPatchLib

do {
    try PodPatch().run(Array(CommandLine.arguments.dropFirst()))
} catch {
    print(error.localizedDescription)
}
