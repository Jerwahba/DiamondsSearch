const { formatResults } = require('./format-results.js');

// Test single request
console.log("=== Test Single Request ===");
const singleFilters = {
    request_text: "Je cherche un diamant rond de 2 carats couleur F",
    shape: "round",
    weight: 2,
    color: "F"
};

const singleResults = [
    {
        shape: "round",
        weight: 2.15,
        color: "F",
        clarity: "VS1",
        total_price: 18500,
        ddp: "https://example.com/diamond/12345"
    }
];

console.log("Single filters type:", typeof singleFilters, Array.isArray(singleFilters));
console.log("Single filters:", singleFilters);
const singleMessage = formatResults(singleFilters, singleResults);
console.log("Single message:", singleMessage);

// Test multiple requests
console.log("\n=== Test Multiple Requests ===");
const multipleFilters = [
    {
        request_text: "Je cherche un diamant de 2 carats ET un diamant de 3 carats",
        request_number: 1,
        weight: 2
    },
    {
        request_text: "Je cherche un diamant de 2 carats ET un diamant de 3 carats", 
        request_number: 2,
        weight: 3
    }
];

const multipleResults = [
    {
        request_number: 1,
        shape: "round",
        weight: 2.15,
        color: "F",
        clarity: "VS1",
        total_price: 18500
    },
    {
        request_number: 2,
        shape: "princess",
        weight: 3.02,
        color: "G",
        clarity: "VS2",
        total_price: 25000
    }
];

console.log("Multiple filters type:", typeof multipleFilters, Array.isArray(multipleFilters));
console.log("Multiple filters:", multipleFilters);
const multipleMessage = formatResults(multipleFilters, multipleResults);
console.log("Multiple message:", multipleMessage); 