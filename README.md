# Scout
Scouting for Property

Usage: Currently runs locally. If you want to follow my (rudimentary) user story and workplan, it is available in Pseudocode.md.

Things you can do:
1) Seed the Database:
I've included my working set of past deals in perth_amboy_0816.csv. These can be imported using Locations.import. In your commandline, hit Locations.import(perth_amboy_0816.csv)

2) Search out a target:
A target, in this schema, is a location of interest. It could also be an actual deal that you want to diligence. Running on local, go into the ui (ie. run rails s and then hit localhost in your browser) and click "New Target". You can provide lat/long or an address (and address field hits google so can be nearly anything, though it helps to throw in a zipcode). Then give a radius in miles. 0.1 is a good starting point for speed purposes.

The target is geocoded, and we set out a square with the specified radius. We check the square in increments for valid addresses, and create them as Locations.

Locations are bumped against the Zillow API to see whether they have a house at them, and if yes, various relevant information is pulled against them: Pricing info, sizing, and other metadata. See AddressInformation to see exactly what.

3) Browse locations:
The main page is a list of locations. You can see their various info, such as location, sizing and pricing data, etc. Clicking on 'show' for a location will pull up its spot on a map, as well as other DB entries nearby. One UX goal might be to drop all these pins on the map and color-code them by caprate or some other useful metric.

--

Ideal full use case:
1) Type a `target`
2) Target pulls all sales and rental comp `locations` within `radius`.
3) Run metrics, especially valuation metric like `caprate`.
4) Publish a map that shows `locations` within radius of `target`, labeled with `caprate` information, as well as flagged for actually available listings.
5) Indicate interest in an available listing to publish an offer to the agent at the `target_price`.
