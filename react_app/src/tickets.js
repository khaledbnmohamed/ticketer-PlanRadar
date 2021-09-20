
import axios from "axios";
import * as config from "./config";


export const createTicket = async (formDetails, pathParams) => {
  const url = config.getApiUrl({ endpoint: "create_ticket", pathParams });

  const response = await axios.post(url, formDetails)
    .then((res) => ({ data: res.data }))
    .catch((error) => ({ data: error, hasError: true }));
  return response;
};

//   export const editContract = async (formDetails, pathParams) => {
//   const url = config.getApiUrl({ endpoint: "contract_edit", pathParams });
//   const headers = {
//     Authorization: Cookies.get(config.MRN_JWT_COOKIE),
//   };
//   const response = await axios.put(url, formDetails, { headers })
//     .then((res) => ({ data: res.data }))
//     .catch((error) => ({ data: error, hasError: true }));
//   return response;
// };

export const listTickets = async (pathParams) => {
  const url = config.getApiUrl({ endpoint: "list_tickets", pathParams });


  const response = await axios.get(url)
    .then((res) => ({ data: res.data }))
    .catch((error) => ({ data: error, hasError: true }));
  return response;
};


export function getApiUrl({
  endpoint, pathParams = {}, queryParams = {}, version = "v1", baseUrl = appBaseUrl,
}) {
  let apiUrl = endpoints[endpoint];
  if (!apiUrl) throw new Error("Unknown endpoint given to 'getApiUrl' function");

  for (const [key, value] of Object.entries(pathParams)) {
    apiUrl = apiUrl.replace((`:${key}`), value);
  }
  // eslint-disable-next-line no-use-before-define
  apiUrl = apiUrlWithQueryParams(apiUrl, queryParams);
  return [baseUrl, version, apiUrl].filter((item) => item).join("/");
}

export const apiUrlWithQueryParams = (apiUrl, queryParams) => {
  if (typeof queryParams === "string") {
    return `${apiUrl}?${queryParams}`;
  }

  const queryParamsLength = Object.keys(queryParams).length;
  if (queryParamsLength > 0) {
    // eslint-disable-next-line no-param-reassign
    apiUrl += "?";
    let i = 1;// as we don't want to append '&' @ the end of the url
    for (const [key, value] of Object.entries(queryParams)) {
      if (Array.isArray(value)) {
        let j = 1;
        for (const val of Object.entries(value)) {
          const newKey = `${key}[]`;
          // eslint-disable-next-line no-param-reassign
          apiUrl += `${encodeURI(newKey)}=${val[1]}`;
          // this will check value of 'j' then increament it <3
          // eslint-disable-next-line no-plusplus
          if (j++ < value.length) {
            // eslint-disable-next-line no-param-reassign
            apiUrl += "&";
          }
        }
      } else {
        // eslint-disable-next-line no-param-reassign
        apiUrl += `${encodeURI(key)}=${value}`;
      }
      // this will check value of 'i' then increament it <3
      // eslint-disable-next-line no-plusplus
      if (i++ < queryParamsLength) {
        // eslint-disable-next-line no-param-reassign
        apiUrl += "&";
      }
    }
  }
  return apiUrl;
};
