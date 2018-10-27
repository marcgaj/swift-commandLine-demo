class View: Codable {
    var identifier: String?
    var subviews: [View]?
    var contentView: View?
    var classId: String?
    var classNames: [String]?
    var control: View?
    
    enum CodingKeys: String, CodingKey {
        case classId = "class"
        case identifier
        case subviews
        case contentView
        case classNames
        case control
    }
    
    func find(_ s: String) -> [View] {
        if s.trimmingCharacters(in: [" "]).contains(" ") {
            let sections = s.split(separator: " ", maxSplits: 1)
            if self.matches(query: String(sections[0])) { return self.find(String(sections[1])) }
            return []
        }
        else {
            var views = [View]()
            for view in searchChildren(for: s){
                if view.matches(query: s) { views.append(view)}
            }
            if self.matches(query: s) { views.append(self) }
            if let control = control,
                control.matches(query: s) {
                views.append(control) }
            
            return views
        }
    }
    
    private func searchChildren(for s: String) -> [View] {
        var children = [View]()
        for view in subviews ?? [] {
            for views in view.find(s) {
                children.append(views) }
        }
        for view in contentView?.find(s) ?? [] { children.append(view) }
        
        return children
    }
    
    func matches(query s: String) -> Bool {
        let keys = utils.getSelectors(from: s)
        
        if keys.count == 1, keys[.classId] != nil, keys[.classId]!.isEmpty { return false }
        if let id = keys[.id], identifier != id { return false }
        if let id = keys[.className], classNames == nil || !(classNames!.contains(id)) { return false }
        if let id = keys[.classId], !id.isEmpty && classId != id { return false }
        
        return true
    }
}
