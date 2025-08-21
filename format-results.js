function formatResults(filters, results) {
    // Check if this is a multiple requests response
    if (Array.isArray(filters)) {
        return formatMultipleRequests(filters, results);
    }
    
    // Handle single request (existing logic)
    let message = "Voici les résultats de votre recherche :\n\n";
    
    // Add customer's original request if available
    if (filters.request_text) {
        message += `*Votre demande :* ${filters.request_text}\n\n`;
    }

    // Build a summary of the filters used
    const filterParts = [];
    if (filters.shape) filterParts.push(`Forme : ${filters.shape}`);
    if (filters.weight) {
        filterParts.push(`Carat : ${filters.weight}`);
    } else if (filters.weight_min && filters.weight_max) {
        if (filters.weight_min === filters.weight_max) {
            filterParts.push(`Carat : ${filters.weight_min}`);
        } else {
            filterParts.push(`Carat : ${filters.weight_min} - ${filters.weight_max}`);
        }
    }
    if (filters.color) filterParts.push(`Couleur : ${filters.color}`);
    if (filters.clarity) filterParts.push(`Clarté : ${filters.clarity}`);
    if (filters.cut) filterParts.push(`Taille : ${filters.cut}`);
    if (filters.lab) filterParts.push(`Certificat : ${filters.lab}`);

    if (filterParts.length > 0) {
        message += `*Critères extraits :* ${filterParts.join(', ')}\n\n`;
    }

    if (results.length === 0) {
        message += "Nous n'avons trouvé aucun diamant correspondant à vos critères. N'hésitez pas à élargir votre recherche.";
        return message;
    }

    message += `*${results.length} diamant(s) trouvé(s) :*\n\n`;

    // Add details for each diamond
    results.forEach((diamond, index) => {
        message += `*Diamant ${index + 1}*\n`;
        message += `  - Forme : ${diamond.shape}\n`;
        message += `  - Carat : ${diamond.weight}\n`;
        message += `  - Couleur : ${diamond.color}\n`;
        message += `  - Clarté : ${diamond.clarity}\n`;
        if (diamond.cut) message += `  - Taille : ${diamond.cut}\n`;
        if (diamond.lab) message += `  - Certificat : ${diamond.lab}\n`;
        if (diamond.location) message += `  - Lieu : ${diamond.location}\n`;
        if (diamond.total_price) {
            message += `  - *Prix : ${diamond.total_price.toLocaleString('fr-FR', { style: 'currency', currency: 'USD' })}*\n`;
        }
        if (diamond.ddp) {
            // Check if it's a valid URL or just text
            const ddpValue = diamond.ddp.toString();
            if (ddpValue.startsWith('http://') || ddpValue.startsWith('https://')) {
                message += `  - *DDP :* ${ddpValue}\n`;
            } else if (ddpValue.toLowerCase().includes('stone details link') || ddpValue.toLowerCase().includes('link')) {
                message += `  - *DDP :* Lien non disponible\n`;
            } else {
                message += `  - *DDP :* ${ddpValue}\n`;
            }
        }
        message += `\n`;
    });
    
    return message;
}

function formatMultipleRequests(filtersArray, allResults) {
    let message = "Voici les résultats de vos recherches multiples :\n\n";
    
    filtersArray.forEach((filters, requestIndex) => {
        const requestNumber = filters.request_number || (requestIndex + 1);
        const requestText = filters.request_text || `Demande ${requestNumber}`;
        
        message += `*=== Demande ${requestNumber} ===*\n`;
        message += `*Votre demande :* ${requestText}\n\n`;
        
        // Build a summary of the filters used for this request
        const filterParts = [];
        if (filters.shape) filterParts.push(`Forme : ${filters.shape}`);
        if (filters.weight) {
            filterParts.push(`Carat : ${filters.weight}`);
        } else if (filters.weight_min && filters.weight_max) {
            if (filters.weight_min === filters.weight_max) {
                filterParts.push(`Carat : ${filters.weight_min}`);
            } else {
                filterParts.push(`Carat : ${filters.weight_min} - ${filters.weight_max}`);
            }
        }
        if (filters.color) filterParts.push(`Couleur : ${filters.color}`);
        if (filters.clarity) filterParts.push(`Clarté : ${filters.clarity}`);
        if (filters.cut) filterParts.push(`Taille : ${filters.cut}`);
        if (filters.lab) filterParts.push(`Certificat : ${filters.lab}`);

        if (filterParts.length > 0) {
            message += `*Critères extraits :* ${filterParts.join(', ')}\n\n`;
        }
        
        // Filter results that belong to this specific request
        const requestResults = allResults.filter(result => result.request_number === requestNumber);
        
        if (requestResults.length === 0) {
            message += "Aucun diamant trouvé pour cette demande.\n\n";
        } else {
            message += `*${requestResults.length} diamant(s) trouvé(s) :*\n\n`;
            
            // Add details for each diamond in this request
            requestResults.forEach((diamond, index) => {
                message += `*Diamant ${index + 1}*\n`;
                message += `  - Forme : ${diamond.shape}\n`;
                message += `  - Carat : ${diamond.weight}\n`;
                message += `  - Couleur : ${diamond.color}\n`;
                message += `  - Clarté : ${diamond.clarity}\n`;
                if (diamond.cut) message += `  - Taille : ${diamond.cut}\n`;
                if (diamond.lab) message += `  - Certificat : ${diamond.lab}\n`;
                if (diamond.location) message += `  - Lieu : ${diamond.location}\n`;
                if (diamond.total_price) {
                    message += `  - *Prix : ${diamond.total_price.toLocaleString('fr-FR', { style: 'currency', currency: 'USD' })}*\n`;
                }
                if (diamond.ddp) {
                    // Check if it's a valid URL or just text
                    const ddpValue = diamond.ddp.toString();
                    if (ddpValue.startsWith('http://') || ddpValue.startsWith('https://')) {
                        message += `  - *DDP :* ${ddpValue}\n`;
                    } else if (ddpValue.toLowerCase().includes('stone details link') || ddpValue.toLowerCase().includes('link')) {
                        message += `  - *DDP :* Lien non disponible\n`;
                    } else {
                        message += `  - *DDP :* ${ddpValue}\n`;
                    }
                }
                message += `\n`;
            });
        }
        
        message += "\n";
    });
    
    return message;
}

module.exports = { formatResults }; 