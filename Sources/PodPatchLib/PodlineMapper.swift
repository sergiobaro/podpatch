import Foundation

class PodlineMapper {

  func map(podline: Podline, args: Args) -> PodToWrite {
    let optionsOrder = mapOptionsOrder(podline, args: args)
    let options = mapOptions(podline, args: args)
    let optionsToCommentOut = mapOptionsToCommentOut(options, args: args)

    return .init(
      prefix: podline.prefix,
      podName: podline.podName,
      optionsOrder: optionsOrder,
      options: options,
      isMultiline: podline.isMultiline,
      optionsToCommentOut: optionsToCommentOut
    )
  }

  private func mapOptionsOrder(_ podline: Podline, args: Args) -> [String] {
    if podline.optionsOrder.contains(args.property.rawValue) {
      if args.property != .path, let index = podline.optionsOrder.firstIndex(of: PodProperty.path.rawValue) {
        var order = podline.optionsOrder
        order.remove(at: index)
        return order
      }
      return podline.optionsOrder
    }

    return [args.property.rawValue] + podline.optionsOrder
  }

  private func mapOptions(_ podline: Podline, args: Args) -> [String: String] {
    var options = podline.options

    if args.property != .path {
      options[PodProperty.path.rawValue] = nil
    }
    options[args.property.rawValue] = "'\(args.value)'"

    return options
  }

  private func mapOptionsToCommentOut(_ options: [String: String], args: Args) -> [String] {
    let keepOptions = optionsToKeep(options)
    return Array(Set(options.keys).subtracting(keepOptions))
  }

  private func optionsToKeep(_ options: [String: String]) -> [String] {
    guard options.keys.contains(PodProperty.path.rawValue) else {
      return Array(options.keys)
    }

    var options = options
    options.removeValue(forKey: PodProperty.branch.rawValue)
    options.removeValue(forKey: PodProperty.git.rawValue)

    return Array(options.keys)
  }
}
