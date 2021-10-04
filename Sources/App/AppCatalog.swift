/**
 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU Affero General Public License as
 published by the Free Software Foundation, either version 3 of the
 License, or (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU Affero General Public License for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */
import FairApp
import SwiftUI

@available(macOS 12.0, iOS 15.0, *)
extension AppCatalogItem {

    /// All the entitlements, ordered by their index in the `AppEntitlement` cases.
    public func orderedEntitlements(filterCategories: Set<AppEntitlement.Category> = []) -> Array<AppEntitlement> {
        let activeEntitlements = self.entitlements
            .filter {
                $0.categories.intersection(filterCategories).isEmpty
            }
        return AppEntitlement.allCases.filter(activeEntitlements.contains)
    }

    /// A relative score summarizing how risky the app appears to be from a scale of 0–5
    var riskLevel: Int {
        // let groups = Set(item.appCategories.flatMap(\.groupings))
        let categories = Set(self.entitlements.flatMap(\.categories)).subtracting([.prerequisite, .harmless])
        // the naieve classification just counts the categories
        return max(0, min(5, categories.count))
    }

    func riskColor() -> Color {
        switch riskLevel {
        case 0: return Color.green
        case 1: return Color.mint
        case 2: return Color.yellow
        case 3: return Color.orange
        default: return Color.red
        }
    }

    /// The label summarizing how risky the app appears to be
    func riskLabel() -> some View {
        Group {
            let level = riskLevel
            switch level {
            case 0...50:
                riskText()
                    .label(image: Image(systemName: "\(level)"))
                    .foregroundStyle(riskColor())
            default:
                riskText()
                    .label(image: Image(systemName: "exclamationmark.triangle.fill"))
            }
        }
        .symbolVariant(.square)
        .symbolVariant(.fill)
        .symbolRenderingMode(SymbolRenderingMode.hierarchical)
        .help(Text("Based on the number of permission categories this app requests this app can be considered: ") + riskText())
    }

    /// The text summarizing how risky the app appears to be
    func riskText() -> Text {
        switch riskLevel {
        case 0:
            return Text("Harmless")
        case 1:
            return Text("Mostly Harmless")
        case 2:
            return Text("Risky")
        case 3:
            return Text("Hazardous")
        case 4:
            return Text("Dangerous")
        default:
            return Text("Perilous")
        }
    }
}

extension AppEntitlement : Identifiable {
    public var id: Self { self }

    /// Returns a text view with a description and summary of the given entitlement
    var localizedInfo: (title: Text, info: Text, symbol: String) {
        switch self {
        case .app_sandbox:
            return (
                Text("Sandbox"),
                Text("The Sandbox entitlement entitlement ensures that the app will run in a secure container."),
                "shield.fill")
        case .network_client:
            return (
                Text("Network Client"),
                Text("Communicate over the internet and any local networks."),
                "globe")
        case .network_server:
            return (
                Text("Network Server"),
                Text("Handle network requests from the local network or the internet."),
                "globe.badge.chevron.backward")
        case .device_camera:
            return (
                Text("Camera"),
                Text("Use the device camera."),
                "camera")
        case .device_microphone:
            return (
                Text("Microphone"),
                Text("Use the device microphone."),
                "mic")
        case .device_usb:
            return (
                Text("USB"),
                Text("Access USB devices."),
                "cable.connector.horizontal")
        case .print:
            return (
                Text("Printing"),
                Text("Access printers."),
                "printer")
        case .device_bluetooth:
            return (
                Text("Bluetooth"),
                Text("Access bluetooth."),
                "b.circle.fill")
        case .device_audio_video_bridging:
            return (
                Text("Audio/Video Bridging"),
                Text("Permit Audio/Bridging."),
                "point.3.connected.trianglepath.dotted")
        case .device_firewire:
            return (
                Text("Firewire"),
                Text("Access Firewire devices."),
                "bolt.horizontal")
        case .device_serial:
            return (
                Text("Serial"),
                Text("Access Serial devices."),
                "arrow.triangle.branch")
        case .device_audio_input:
            return (
                Text("Audio Input"),
                Text("Access Audio Input devices."),
                "lines.measurement.horizontal")
        case .personal_information_addressbook:
            return (
                Text("Address Book"),
                Text("Access the user's personal address book."),
                "text.book.closed")
        case .personal_information_location:
            return (
                Text("Location"),
                Text("Access the user's personal location information."),
                "location")
        case .personal_information_calendars:
            return (
                Text("Calendars"),
                Text("Access the user's personal calendar."),
                "calendar")
        case .files_user_selected_read_only:
            return (
                Text("User-Selected Read-Only"),
                Text("Read access to files explicitly selected by the user."),
                "doc")
        case .files_user_selected_read_write:
            return (
                Text("User-Selected Read-Write"),
                Text("Read and write access to files explicitly selected by the user."),
                "doc.fill")
        case .files_user_selected_executable:
            return (
                Text("User-Selected Executable"),
                Text("Read access to executables explicitly selected by the user."),
                "doc.text.below.ecg")
        case .files_downloads_read_only:
            return (
                Text("Downloads Read-Only"),
                Text("Read access to the user's Downloads folder"),
                "arrow.up.and.down.square")
        case .files_downloads_read_write:
            return (
                Text("Downloads Read-Write"),
                Text("Read and write access to the user's Downloads folder"),
                "arrow.up.and.down.square.fill")
        case .assets_pictures_read_only:
            return (
                Text("Pictures Read-Only"),
                Text("Read access to the user's Pictures folder"),
                "photo")
        case .assets_pictures_read_write:
            return (
                Text("Pictures Read-Write"),
                Text("Read and write access to the user's Pictures folder"),
                "photo.fill")
        case .assets_music_read_only:
            return (
                Text("Music Read-Only"),
                Text("Read access to the user's Music folder"),
                "radio")
        case .assets_music_read_write:
            return (
                Text("Music Read-Write"),
                Text("Read and write access to the user's Music folder"),
                "radio.fill")
        case .assets_movies_read_only:
            return (
                Text("Movies Read-Only"),
                Text("Read access to the user's Movies folder"),
                "film")
        case .assets_movies_read_write:
            return (
                Text("Movies Read-Write"),
                Text("Read and write access to the user's Movies folder"),
                "film.fill")
        case .files_all:
            return (
                Text("All Files"),
                Text("Read and write all files on the system."),
                "doc.on.doc.fill")
        case .cs_allow_jit:
            return (
                Text("Just-In-Time Compiler"),
                Text("Enable performace booting."),
                "hare")
        case .cs_debugger:
            return (
                Text("Debugging"),
                Text("Allows the app to act as a debugger and inspect the internal information of other apps in the system."),
                "stethoscope")
        case .cs_allow_unsigned_executable_memory:
            return (
                Text("Unsigned Executable Memory"),
                Text("Permit and app to create writable and executable memory without the restrictions imposed by using the MAP_JIT flag."),
                "hammer")
        case .cs_allow_dyld_environment_variables:
            return (
                Text("Dynamic Linker Variables"),
                Text("Permit the app to be affected by dynamic linker environment variables, which can be used to inject code into the app's process."),
                "screwdriver")
        case .cs_disable_library_validation:
            return (
                Text("Disable Library Validation"),
                Text("Permit the app to load arbitrary plug-ins or frameworks without requiring code signing."),
                "wrench")
        case .cs_disable_executable_page_protection:
            return (
                Text("Disable Executable Page Protection"),
                Text("Permits the app the disable all code signing protections while launching an app and during its execution."),
                "bandage")
        case .scripting_targets:
            return (
                Text("Scripting Target"),
                Text("Ability to use specific scripting access groups within a specific scriptable app."),
                "scroll")
        case .application_groups:
            return (
                Text("Application Groups"),
                Text("Share files and preferences between applications."),
                "square.grid.3x3.square")
        case .files_bookmarks_app_scope:
            return (
                Text("File Bookmarks App-Scope"),
                Text("Enables use of app-scoped bookmarks and URLs."),
                "bookmark.fill")
        case .files_bookmarks_document_scope:
            return (
                Text("File Bookmarks Document-Scope"),
                Text("Enables use of document-scoped bookmarks and URLs."),
                "bookmark")
        case .files_home_relative_path_read_only:
            return (
                Text("User Home Files Read-Only"),
                Text("Enables read-only access to the specified files or subdirectories in the user's home directory."),
                "doc.badge.ellipsis")
        case .files_home_relative_path_read_write:
            return (
                Text("User Home Files Read-Write"),
                Text("Enables read/write access to the specified files or subdirectories in the user's home directory."),
                "doc.fill.badge.ellipsis")
        case .files_absolute_path_read_only:
            return (
                Text("Global Files Read-Only"),
                Text("Enables read-only access to the specified files or directories at specified absolute paths."),
                "doc.badge.gearshape")
        case .files_absolute_path_read_write:
            return (
                Text("Global Files Read-Write"),
                Text("Enables read/write access to the specified files or directories at specified absolute paths."),
                "doc.badge.gearshape.fill")
        case .apple_events:
            return (
                Text("Apple Events"),
                Text("Enables sending of Apple events to one or more destination apps."),
                "scroll.fill")
        case .audio_unit_host:
            return (
                Text("Audio Unit Host"),
                Text("Enables hosting of audio components that are not designated as sandbox-safe."),
                "waveform")
        case .iokit_user_client_class:
            return (
                Text("IOKit User Client"),
                Text("Ability to specify additional IOUserClient subclasses."),
                "waveform.badge.exclamationmark")
        case .mach_lookup_global_name:
            return (
                Text("MACH Global Name Lookup"),
                Text("Lookup global Mach services."),
                "list.bullet.rectangle")
        case .mach_register_global_name:
            return (
                Text("Mach Global Name Register"),
                Text("Register global Mach services."),
                "list.bullet.rectangle.fill")
        case .shared_preference_read_only:
            return (
                Text("Shared Preferences Read-Only"),
                Text("Read shared preferences."),
                "list.triangle")
        case .shared_preference_read_write:
            return (
                Text("Shared Preferences Read-Write"),
                Text("Read and write shared preferences."),
                "list.star")
        }
    }
}