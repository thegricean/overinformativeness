# Overinformativeness
## Notes and ideas from the papers by Judith

### Summary of papers

1. Pechmann (1989): "Incremental Speech Production and referential overspecification"

  - Main claim: Speakers produce speech incrementally
    - Start to produce an utterance before having fully determined the nonlinguistic info incorporated in utterance
    - "articulation before conceptualization"
    - this explains 
      - overinformativeness
      - irregularities of prenominal adjective order
  - Intersting other points made in the paper:
    - An *alternate explanation for OI*: In information theory, a positive function is assigned to redundancy, since it can compensate for partial loss of information
    - Pechmann emphasizes the use of *overspecification* instead of *redundancy* (-> overspecification opposed to minimal and under- specification)
      - Redundancy entails that the extra information does not contribute to informativeness of utterance
        - **However**, overinformative statements *are* informative, as they exclude distractors and thus have a (positive!) effect on the processing of the listener
        - This is **counterevidence** to the claim that speakers are irrational by being overinformative
    - Salience determines *adjective order*
      - sometimes adjective order preferences can be inversed

2. Sedivy (2003): "Pragmatic vs. form-based accounts of referential contrast: Evidence for effects of informativity expectations"

  - Main claim: Color adjectives lead to OI, material and scalar (size) adjectives do not
  - Referential contrast effects originate in *expectations of informativity* rather in semantics of adjectives
   - A) there are online processing effects of referential contrast -> adjective leads to inference of contrastive function (e.g. "small cup" has a processing advantage if a "big cup" is also present opposed to when no "big cup" is present)
   - B) The typicality/rarity of encountering an adjective as part of a typical/rare means of describing the object has an influence on this contrastive function
     - if an adjective is an orthogonal property (e.g. color adj + cup/book/chair (default description *does* include a color????)), then there is no inference of contrastive function (no processing advantage when saying "red cup" when there's a blue cup in the display opposed to when there is no blue cup in the display)
       - **This doesn't make sense to me, why would orthogonal color adjs be used as a default?!**
     - if an adjective is typical for the noun it's describing (e.g yellow banana; i.e. the default description *does not* include a color (???)), then there is an inference of contrastive function (-> listener reasons that in the default case the speaker wouldn't have used the color, but he did, so this must be due to the communicative goal of contrasting the object to another object)
     - if an adjective is atypical (e.g. purple banana; i.e. the ~~default description~~ this has nothing to do with the default description, it simply means that the adj is *neither* part of the default description, *nor* can it even occur as a description of this particular noun)
   - Linking A) and B) leads to conclusion that r

## ToDo

**Judith:** 

1. put study on mturk

2. initial pre-processing of speaker data to create columns of color/size mention for each message

**Caroline:**

1. Check automatic message annotation.

2. Add extra columns for type of modification (pre-postnominal).

...then we reconvene and make pretty plots of analyses listed below...

## Analyses

### Listener (sanity checks)

These analyses will just serve as a way for us to identify possibly problematic pairs of subjects.

1. Proportion of target vs other choices on filler trials.

2. Proportion of target vs other choices on target trials (split up by condition).

3. Proportion of trials on which listeners send a message at all. 

4. More fuzzy: when messages are sent, what are they for? Requests for clarification, standard backchannels ("OK"), etc. --> will require some manual looking into the data.


### Speaker (the real interesting stuff!)

These are the analyses of interest.

1. Proportion of color mention on color-only, size-only, and color-or-size trials.

2. Proportion of size mention on color-only, size-only, and color-or-size trials.

3. Proportion of color-and-size mention on color-only, size-only, and color-or-size trials.

4. Minor sanity check, testing for individual variation in baseline willingness to overmodify: Proportion of color/size mention on filler trials.

Pre-processing to get 1 - 4:

1. Annotate each message for whether it includes a (the correct) color, a (the correct) size, type.

2. For each message, if there was a color modifier, did it occur pre- or post-nominally?

3. For each message, if there was a size modifier, did it occur pre- or post-nominally?

4. Less pressing: If more than one message is sent, what is it for?
