const testimonials= [
    {
        name:"Ilyssa E",
        photourl:"https://media.istockphoto.com/id/1257088545/photo/portrait-of-a-smiling-woman-sitting-outdoors.webp?s=1024x1024&w=is&k=20&c=bZiFc8e_nJD1my4BXnQgs1hdWzARy0lPrMlmdrnEwLw=",
        text:"Thanks to apple, we've just launched our 5th website! Nice work on your apple. I don't know what else to say."
    },
    {
        name:"Sloan L",
        photourl:"https://images.unsplash.com/photo-1654110455429-cf322b40a906?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTZ8fHByb2ZpbGUlMjBwaWN0dXJlfGVufDB8MnwwfHw%3D&auto=format&fit=crop&w=700&q=60",
        text:"Apple is both attractive and highly adaptable. I wish I would have thought of it first. We've used apple for the last five years."
    },
    {
        name:"Remington D ",
        photourl:"https://images.unsplash.com/photo-1657959828022-88aaaffe0265?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MzZ8fHByb2ZpbGUlMjBwaWN0dXJlfGVufDB8MnwwfHw%3D&auto=format&fit=crop&w=700&q=60",
        text:"We have no regrets! We've seen amazing results already. It's all good." 
    },
    {
        name:"Blanch O",
        photourl:"https://images.unsplash.com/photo-1541576980233-97577392db9a?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NTN8fHByb2ZpbGUlMjBwaWN0dXJlfGVufDB8MnwwfHw%3D&auto=format&fit=crop&w=700&q=60",
        text:"Without life, we would have gone bankrupt by now. I love life. I wish I would have thought of it first. You won't regret it."
    },
];
let idx=0;
updateTestimonial();
const imgEl=document.querySelector("img");
const textElement=document.querySelector(".text");
const usernameElement=document.querySelector(".username");
function updateTestimonial(){
    const {name,photourl,text}=testimonials[idx];
    imgEl.src=photourl;
    textElement.innerText=text;
    usernameElement.innerText=name;
    idx++;
    if (idx===testimonials.length) {
        idx=0;
    }
    setTimeout(() => {
        updateTestimonial();
    },3000);
}