/**
 * Fetches a list of comma-separated dates from a text file, finds the first upcoming date,
 * and displays it on the web page.
 */
async function displayNextDate() {
    // The HTML element where we will display the result
    const dateDisplayElement = document.getElementById('next-date');
    console.log("Fetching maintenance dates...");
    try {
        // 1. Fetch the contents of the dates.txt file
        const response = await fetch('/assets/js/maintenance-dates.txt');
        if (!response.ok) {
            throw new Error(`HTTP error! Status: ${response.status}`);
        }
        const text = await response.text();

        // 2. Parse the comma-separated string into an array of date strings
        // .trim() removes any potential leading/trailing whitespace
        const dateStrings = text.trim().split(',');

        // 3. Get today's date, with the time set to the beginning of the day for accurate comparison
        const today = new Date();
        today.setHours(0, 0, 0, 0);

        let nextUpcomingDate = null;

        // 4. Loop through the dates to find the first one that is on or after today
        for (const dateStr of dateStrings) {
            // Create a Date object from the string (e.g., '2026-01-27')
            // Using a T00:00:00 suffix helps avoid timezone interpretation issues
            const eventDate = new Date(dateStr.trim() + 'T00:00:00');

            // Compare the event date with today
            if (eventDate >= today) {
                nextUpcomingDate = eventDate;
                break; // Found the first upcoming date, so we can stop looking
            }
        }

        // 5. Display the result in the HTML
        if (nextUpcomingDate) {
            // Format the date for better readability (e.g., "Tuesday, January 27, 2026")
            const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
            dateDisplayElement.textContent = nextUpcomingDate.toLocaleDateString('en-US', options);
        } else {
            // This message will show if all dates in the file are in the past
            dateDisplayElement.textContent = "No upcoming dates found in the list.";
        }

    } catch (error) {
        // Handle errors like the file not being found
        console.error('Error fetching or processing dates:', error);
        dateDisplayElement.textContent = "Could not load dates.";
    }
}

// Run the function when the page content has finished loading
document.addEventListener('DOMContentLoaded', displayNextDate);