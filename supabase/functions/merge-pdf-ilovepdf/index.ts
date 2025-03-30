// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

// Setup type definitions for built-in Supabase Runtime APIs
import "jsr:@supabase/functions-js/edge-runtime.d.ts"
import ILovePDFApi from "npm:@ilovepdf/ilovepdf-nodejs";

console.log("Hello from Functions!")

Deno.serve(async (req) => {
  console.log("Received request:", req.method, req.url);
  try {
    // Get URLs from request body or query parameters
    let urls = [];
    
    // Check if it's a POST request with JSON body
    if (req.method === 'POST') {
      console.log("Processing POST request");
      try {
        const body = await req.json();
        console.log("Request body:", body);
        if (body.urls && Array.isArray(body.urls)) {
          urls = body.urls;
          console.log("Found URLs in request body:", urls.length);
        }
      } catch (e) {
        console.error("Error parsing JSON body:", e);
      }
    }
    
    // If no URLs in body, try query parameters
    if (urls.length === 0) {
      console.log("No URLs found in body, checking query parameters");
      const url = new URL(req.url);
      const urlsParam = url.searchParams.get('urls');
      
      if (urlsParam) {
        urls = urlsParam.split(',');
        console.log("Found URLs in query parameters:", urls.length);
      }
    }
    
    if (urls.length === 0) {
      console.log("No URLs provided in request");
      return new Response(
        JSON.stringify({ error: "Please provide at least one PDF URL" }),
        { status: 400, headers: { "Content-Type": "application/json" } }
      );
    }

    // Get environment variables
    console.log("Retrieving iLovePDF credentials");
    const publicKey = Deno.env.get("ILOVEPDF_CLIENT_ID");
    const secretKey = Deno.env.get("ILOVEPDF_CLIENT_SECRET");

    if (!publicKey || !secretKey) {
      console.error("Missing iLovePDF credentials");
      return new Response(
        JSON.stringify({ error: "Missing iLovePDF credentials" }),
        { status: 500, headers: { "Content-Type": "application/json" } }
      );
    }

    // Initialize iLovePDF client
    console.log("Initializing iLovePDF client");
    const ilovepdf = new ILovePDFApi(publicKey, secretKey);
    const task = ilovepdf.newTask('merge');

    // Start the task
    console.log("Starting merge task");
    await task.start();

    // Download and add each PDF from the provided URLs
    console.log("Adding PDFs to merge task");
    for (let i = 0; i < urls.length; i++) {
      const url = urls[i];
      console.log(`Full URL for PDF ${i+1}/${urls.length}: ${url}`);
      const encodedUrl = url;
      console.log(`Adding PDF ${i+1}/${urls.length} from: ${encodedUrl}`);
      await task.addFile(encodedUrl);
    }

    // Execute the merge task
    console.log("Processing merge task...");
    await task.process();
    console.log("Merge task processed successfully");
    
    // Get the download URL
    console.log("Getting download URL...");
    const downloadData = await task.download();
    console.log("Download URL obtained");
    
    // Return the download URL as JSON
    console.log("Returning response with download URL");
    return new Response(
      JSON.stringify({ 
        success: true, 
        downloadUrl: downloadData.url || downloadData 
      }),
      { 
        headers: { 
          "Content-Type": "application/json"
        } 
      }
    );
  // deno-lint-ignore no-explicit-any
  } catch (error: any) {
    console.error("Error merging PDFs:", error);
    return new Response(
      JSON.stringify({ error: `Failed to merge PDFs: ${error.message}` }),
      { status: 500, headers: { "Content-Type": "application/json" } }
    );
  }
})

/* To invoke locally:

  1. Run `supabase start` (see: https://supabase.com/docs/reference/cli/supabase-start)
  2. Make an HTTP request:

  curl -i --location --request GET 'http://127.0.0.1:54321/functions/v1/merge-pdf-ilovepdf?urls=https://example.com/pdf1.pdf,https://example.com/pdf2.pdf' \
    --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0'

*/
