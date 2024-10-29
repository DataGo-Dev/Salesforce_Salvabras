

export function formatDate(value, includeYear = false, includeTime = false) {
    if (!value) return ''; 

    const date = new Date(value);
    const day = String(date.getUTCDate()).padStart(2, '0'); 
    const month = String(date.getUTCMonth() + 1).padStart(2, '0');
    const year = date.getUTCFullYear(); 

    let formattedDate = `${day}/${month}`; 

    if(includeYear){
        formattedDate += `/${year}`;
    }

    if (includeTime) {
        const hours = String(date.getUTCHours()).padStart(2, '0');
        const minutes = String(date.getUTCMinutes()).padStart(2, '0'); 
        formattedDate += ` ${hours}:${minutes}`; 
    }

    return formattedDate;
}

export function remapData(data) {
    return data.map(row => _flattenRow(row));
}

export function _flattenRow(row) {
    const flattenedRow = {};

    const flattenObject = (obj, parentKey = '') => {
        Object.keys(obj).forEach(key => {
            const fullKey = parentKey ? `${parentKey}.${key}` : key;
            const value = obj[key];
            if (typeof value === 'object' && value !== null && !Array.isArray(value)) {
                flattenObject(value, fullKey); 
            } else {
                flattenedRow[fullKey] = value; 
            }
        });
    };
    flattenObject(row);
    return flattenedRow;
}

export function keysToLower(obj) {

    const lowerize = (obj) =>
        Object.keys(obj).reduce((acc, k) => {
          acc[k.toLowerCase()] = obj[k];
          return acc;
        }, {});
    obj = lowerize(obj);

    return obj; 
}

export function generateId(tamanho) {
    const caracteres = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    let resultado = '';
    for (let i = 0; i < tamanho; i++) {
        resultado += caracteres.charAt(Math.floor(Math.random() * caracteres.length));
    }
    return resultado;
}

export function findMessage(obj) {
    for (const key in obj) {
        if (obj.hasOwnProperty(key)) {
            if (key === 'message') {
                return obj[key];
            } else if (typeof obj[key] === 'object' && obj[key] !== null) {
                const result = findMessage(obj[key]); 
                if (result) {
                    return result;
                }
            }
        }
    }
    return null;
}