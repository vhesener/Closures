import UIKit;import PlaygroundSupport;PlaygroundPage.current.liveView = viewController
import Closures
//: [Go back](@previous)
/*:
 # UITableView
 ## Delegate and DataSource
 
 `UITableView` closures make it easy to implement `UITableViewDelegate` and
 `UITableViewDataSource` protocol methods in an organized way. The following
 is an example of a simple table view that displays strings in a basic cell.
 */
let tableView = viewController.tableView!
let countries = getAllCountries()

func loadTableView() {
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    
    tableView
        .numberOfRows { _ in
            countries.count
        }.cellForRow { indexPath in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel!.text = countries[indexPath.row]
            return cell
        }.didSelectRowAt {
            print("\(countries[$0.row]) selected")
        }.reloadData()
}
loadTableView()
/*:
 ## Arrays
 These operations are common. Usually, they involve populating the `UITableView`
 with the values from an array. `Closures` framework gives you a convenient
 way to pass your array to the table view, so that it can perform the boiler
 plate operations for you, especially the ones that are required to make the table
 view perform at a basic level.
 */
/*:
 Let's setup our segmented control to load the table view with different options.
 When binding to an Array it will show the same countries, but reversed, so
 you can visually see the change after tapping the segmented control.
 */
let segmentedControl = viewController.segmentedControl!
segmentedControl.onChange {
    switch $0 {
    case 1:
        loadTableView(countries: Array(countries.reversed()))
    case 2:
        loadTableView(countries: countries.sectionedByFirstLetter)
    default:
        loadTableView()
    }
}
/*:
 * Important:
 Please remember that Swift `Array`s are value types. This means that they
 are copied when mutated. When the values or sequence of your array changes, you will
 need to call `addElements` again, just before you call reloadData().
 */
func loadTableView(countries: [String]) {
    tableView
        .addElements(countries, cell: UITableViewCell.self) { country, cell, index in
            cell.textLabel!.text = country
        }.reloadData()
}
/*:
 ### Multiple Sections
 * * * *
 And finally, you can just as easily have a grouped table view, by binding a
 2-dimensional array. Before calling this method, we grouped the countries by their
 first letter.
 */
func loadTableView(countries: [[String]]) {
    tableView.addSections(
        countries,
        cell: UITableViewCell.self,
        headerTitle: { countryArray,index in
            String(countryArray.first!.first!)},
        row: { country, cell, index in
            cell.textLabel!.text = country
    })
    
    /**
     This also allows you to override any default behavior so
     you aren't overly committed, even though you're initially binding everything
     to the `Array`.
     */
    tableView
        .estimatedHeightForHeaderInSection { _ in
            30
        }.heightForHeaderInSection { _ in
            30
        }.reloadData()
}
//: * * * *
//: [Click here to explore using **UICollectionView** closures](@next)
//: * * * *
